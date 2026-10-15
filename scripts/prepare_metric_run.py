"""Prepare an isolated directory for rescoring released predictions."""
import argparse
import gzip
import shutil
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
H=ROOT/'benchmark/references'
CODE=ROOT/'evaluation/metrics'

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--model',action='append',required=True,help='Exact released display name; repeat to select more')
    args=ap.parse_args()
    names={p.name.removesuffix('_predictions.jsonl') for p in (ROOT/'results/per_case').glob('*_predictions.jsonl')}
    if set(args.model)-names:ap.error('Unknown model: '+str(sorted(set(args.model)-names)))
    if args.output.exists():ap.error('Choose a new output directory to avoid mixing scoring checkpoints')
    args.output.mkdir(parents=True)
    files=[H/f for f in ['references.jsonl','finance_evidence_catalog.jsonl','finance_evidence_steps.json']]
    files += [CODE/f for f in ['evidence_reference_reader.py','score_evidence_modernbert.py','score_evidence_rouge_roscoe.py',
        'modernbert_sparse_attention.py','score_multireference.py']]
    files += [ROOT/'results/per_case'/(name+'_predictions.jsonl') for name in args.model]
    for src in files:
        dst=args.output/src.name
        if src.exists():shutil.copyfile(src,dst)
        else:
            with gzip.open(str(src)+'.gz','rb') as f,dst.open('wb') as g:shutil.copyfileobj(f,g)
    print('Prepared fresh metric input directory:',args.output)
    print('Run score_evidence_modernbert.py with --device and --model-dir, and score_evidence_rouge_roscoe.py with --device and --embedding-model in that directory.')

if __name__=='__main__':main()
