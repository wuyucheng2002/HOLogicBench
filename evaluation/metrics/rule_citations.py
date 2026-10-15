"""Explicit rule-ID extraction from response text and structured selections."""
import re
import unicodedata

CITE = re.compile(r'\b(?:rules?|articles?|art\.?)\s*(?:no\.?\s*|#\s*|:\s*)?(\d+(?:\.\d+)*(?:(?:\s*[,;&]\s*|\s+(?:and|or)\s+|\s*[-–—]\s*)\d+(?:\.\d+)*)*)', re.I)
SHORT = re.compile(r'\bR\s*#?(\d+)\b', re.I)


def normalize_id(token):
    return str(int(token.split('.')[0]))


def citations(text, domain):
    text = unicodedata.normalize('NFKC', text).replace('*', '').replace('`', '')
    # Equivalent explicit clause notation: Rule 7(2), Article 7 (2).
    text = re.sub(r'(\b(?:rules?|articles?|art\.?)\s*\d+)\s*\((\d+)\)', r'\1.\2', text, flags=re.I)
    out = set()
    for match in CITE.finditer(text):
        run = match[1]
        for token in re.findall(r'\d+(?:\.\d+)*', run):
            if domain == 'finance':out.add(normalize_id(token))
            elif '.' not in token:out.add(int(token))
        for a,b in re.findall(r'(?<![\d.])(\d+(?:\.\d+)*)\s*[-–—]\s*(\d+(?:\.\d+)*)(?![\d.])',run):
            aa=a.split('.');bb=b.split('.')
            if aa[:-1]==bb[:-1] and 0<int(aa[-1])<=int(bb[-1])<=200:
                for n in range(int(aa[-1]),int(bb[-1])+1):
                    token='.'.join(aa[:-1]+[str(n)])
                    if domain=='finance':out.add(normalize_id(token))
                    elif '.' not in token:out.add(int(token))
    short = re.compile(r'\bR\s*#?(\d+(?:\.\d+)*)\b',re.I)
    for m in short.finditer(text):
        if domain=='finance':out.add(normalize_id(m[1]))
        elif '.' not in m[1]:out.add(int(m[1]))
    for m in re.finditer(r'第\s*(\d+)\s*条(?:第?\s*[(（]?(\d+)[)）]?\s*款)?',text):
        if domain=='finance':out.add(normalize_id(m[1]))
        elif not m[2]:out.add(int(m[1]))
    return out


def selected_rules(obj):
    out = set()
    if isinstance(obj, dict):
        for r in obj.get('selected_rules', []):
            token = str(r.get('rule_id', '')) if isinstance(r, dict) else str(r)
            m=re.fullmatch(r'\s*(?:rule\s*)?(\d+(?:\.\d+)*)(?:\s*\((\d+)\))?\s*',token,re.I)
            if m:out.add(normalize_id(m[1]+('.'+m[2] if m[2] else '')))
        for v in obj.values():out.update(selected_rules(v))
    elif isinstance(obj,list):
        for v in obj:out.update(selected_rules(v))
    return out


