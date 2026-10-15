"""Read-only scan of distributed contents, including gzip data, for anonymity risks."""
import argparse
import getpass
import gzip
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROOT_NAMES = ('Users','home','root','tmp','Applications','opt','mnt','workspace',
              'private','var','Volumes','etc','usr','bin','srv')
ABSOLUTE = re.compile(rb'(?<![A-Za-z0-9_./-])/(?:'+b'|'.join(s.encode() for s in ROOT_NAMES)+rb')(?:/[^\s"\x27\\)>,;]*|(?=[\s"\x27\\)>,;]|$))')
WINDOWS = re.compile(rb'\b[A-Za-z]:[\\/](?:Users|Windows|Program Files|work|home)[\\/][^\s"\x27]+',re.I)
SECRET = re.compile(rb'\bsk'+rb'-[A-Za-z0-9_-]{16,}|\bgh[pousr]_[A-Za-z0-9]{20,}|\bAKIA[0-9A-Z]{16}|-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY')
EMAIL = re.compile(rb'[A-Za-z0-9_.+-]{1,80}@[A-Za-z0-9.-]{1,150}\.[A-Za-z]{2,15}')
IPV4 = re.compile(rb'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b')
IP_PREFIX = re.compile(rb'\b[0-9]{1,3}\.')
# Source-level numerical matrix multiplication resembles an email address.
EMAIL_CODE_EXCEPTIONS = {b'he@np.asarray'}


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output',type=Path,help='Optional JSON report; no matched values are recorded')
    args=ap.parse_args()
    output=args.output.resolve() if args.output else None
    username=getpass.getuser().encode()
    known_local_name=username if len(username)>=5 and username.lower() not in {b'anonymous',b'reviewer',b'runner',b'admin'} else None
    findings={};count=0;byte_count=0
    for path in sorted(ROOT.rglob('*')):
        if not path.is_file() or path.is_symlink():continue
        rel=path.relative_to(ROOT)
        if any(x in {'.git','__pycache__','.venv','reproduced','metric_run'} for x in rel.parts):continue
        if path.resolve()==output or path.name=='SHA256SUMS':continue
        if path.name=='.DS_Store' or path.suffix=='.pyc':
            findings.setdefault(str(rel),set()).add('local_cache_metadata')
            continue
        seen=set();tail=b''
        opener=gzip.open if path.suffix=='.gz' else open
        with opener(path,'rb') as stream:
            while True:
                chunk=stream.read(1024*1024)
                if not chunk:break
                byte_count+=len(chunk)
                data=tail+chunk
                # Also detect commonly JSON-escaped path separators/letters.
                if b'\\u00' in data:
                    data=re.sub(rb'\\u00([0-9a-fA-F]{2})',lambda m:bytes([int(m[1],16)]),data)
                data=data.replace(b'\\/',b'/')
                data=data.replace(b'#!'+b'/'+b'usr'+b'/'+b'bin'+b'/'+b'env python3',b'')
                if any((b'/'+s.encode()) in data for s in ROOT_NAMES):
                    if ABSOLUTE.search(data):seen.add('hardcoded_absolute_path')
                if (b':\\' in data or b':/' in data) and WINDOWS.search(data):seen.add('hardcoded_absolute_path')
                if any(needle in data for needle in (b'sk'+b'-', b'ghp'+b'_', b'gho'+b'_', b'ghu'+b'_', b'ghs'+b'_', b'ghr'+b'_', b'AKIA', b'-----BEGIN')):
                    if SECRET.search(data):seen.add('credential_pattern')
                if known_local_name and known_local_name.lower() in data.lower():seen.add('local_username')
                # Limit email matching to small contexts around @, avoiding slow scans
                # across long expressions and serialized formal graphs.
                start=0
                while True:
                    pos=data.find(b'@',start)
                    if pos<0:break
                    for match in EMAIL.finditer(data[max(0,pos-90):pos+180]):
                        if match[0] not in EMAIL_CODE_EXCEPTIONS:seen.add('email_address')
                    start=pos+1
                for prefix in IP_PREFIX.finditer(data):
                    match=IPV4.match(data,prefix.start())
                    if match and all(int(x)<=255 for x in match[0].split(b'.')):seen.add('ipv4_address')
                tail=chunk[-512:]
        count+=1
        if seen:findings[str(rel)]=seen
    report=dict(status='passed' if not findings else 'review_required',
                files_scanned=count,uncompressed_bytes_scanned=byte_count,
                findings={k:sorted(v) for k,v in findings.items()},
                scope=['gzip contents','text and binary contents','common encoded ASCII paths',
                       'local username','credential patterns','email and IPv4 addresses'],
                exceptions=['portable Python interpreter shebang','known matrix-multiplication expression'],
                limitations='Pattern-based audit; public benchmark source institution names are retained. This cannot rule out all indirect identification.')
    if args.output:
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
    if findings:raise SystemExit(1)

if __name__=='__main__':main()
