"""Step segmentation shared with the recorded ROSCOE-SA scoring pipeline."""
import re
def steps(text,domain):
    pattern=r'\n(?=Step \d+:|\[(?:Scenario|Item|Object) )' if domain=='finance' else r'\n+'
    return [x.strip() for x in re.split(pattern,text) if len(x.strip())>5] or [text]
