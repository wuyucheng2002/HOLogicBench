"""Equivalent sparse local SDPA for unpadded ModernBERT inference on MPS."""
import torch
import torch.nn.functional as F
from transformers.models.modernbert import modeling_modernbert as mb
mask_cache={}
def sparse(module,qkv,attention_mask,sliding_window_mask,position_ids,local_attention,bs,dim,**kwargs):
 cos,sin=module.rotary_emb(qkv,position_ids=position_ids)
 q,k,v=qkv.transpose(3,1).unbind(2);q,k=mb.apply_rotary_pos_emb(q,k,cos,sin)
 if local_attention==(-1,-1):o=F.scaled_dot_product_attention(q,k,v,attn_mask=None)
 else:
  B,H,N,D=q.shape;Q=256;radius=local_attention[0];K=Q+2*radius;extra=(-N)%Q;nb=(N+extra)//Q
  qc=F.pad(q,(0,0,0,extra)).reshape(B,H,nb,Q,D).permute(0,2,1,3,4).reshape(B*nb,H,Q,D)
  def blocks(x):return F.pad(x,(0,0,radius,extra+radius)).unfold(2,K,Q).permute(0,2,1,4,3).reshape(B*nb,H,K,D)
  kc,vc=blocks(k),blocks(v)
  key=(N,B,str(q.device))
  if key not in mask_cache:
   if len(mask_cache)>=16:mask_cache.pop(next(iter(mask_cache)))
   qi=torch.arange(Q,device=q.device)[:,None]+radius;ki=torch.arange(K,device=q.device)[None,:]
   local=(qi-ki).abs()<=radius
   positions=torch.arange(nb,device=q.device)[:,None]*Q-radius+torch.arange(K,device=q.device)[None,:]
   valid=(positions>=0)&(positions<N)
   mask_cache[key]=(local[None,None,:,:]&valid[:,None,None,:]).repeat(B,1,1,1)
  o=F.scaled_dot_product_attention(qc,kc,vc,attn_mask=mask_cache[key])
  o=o.reshape(B,nb,H,Q,D).permute(0,2,1,3,4).reshape(B,H,nb*Q,D)[:,:,:N]
 return (o.transpose(1,2).contiguous().view(bs,-1,dim),)

def install(model):
    original_function=mb.MODERNBERT_ATTENTION_FUNCTION['sdpa']
    original_mask=model._update_attention_mask
    def no_padding_mask(attention_mask,output_attentions=False):
        assert not output_attentions
        assert bool(torch.all(attention_mask==1)), 'Sparse adapter only supports unpadded windows'
        return None,None
    mb.MODERNBERT_ATTENTION_FUNCTION['sdpa']=sparse
    model._update_attention_mask=no_padding_mask
    return original_function,original_mask
