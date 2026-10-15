import sys,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'benchmark/law/scripts'));sys.path.insert(0,str(ROOT/'evaluation/metrics'))
from run_llm_evaluation import parse_reasoned_answer,compact_raw_response
from rule_citations import citations,selected_rules
from run_law_v3 import assess
class ProtocolTests(unittest.TestCase):
    def test_answer_markup(self):
        for t in ['Answer: no criminal liability','**Answer:** no criminal liability','**Answer:**\nno criminal liability','**Answer: no criminal liability**','### Answer: no criminal liability','__Answer__: no criminal liability']:
            self.assertEqual(parse_reasoned_answer(t)['answer'],'no criminal liability',t)
        self.assertEqual(parse_reasoned_answer('Reasoning: an Answer: no liability might be possible')['answer'],'')
        self.assertEqual(parse_reasoned_answer('Answer:\n')['answer'],'')
    def test_main_rule_deduplication(self):
        self.assertEqual(citations('Rule 7.2; Rules 7.3-7.5; Article 9(1)','finance'),{'7','9'})
        self.assertEqual(selected_rules({'selected_rules':[{'rule_id':'7.2'},{'rule_id':'7'}]}),{'7'})
    def test_capture_and_truncation(self):
        d={'choices':[{'finish_reason':'length','message':{'content':'partial'}}],'_request_payload':{'max_tokens':32000}}
        self.assertEqual(assess(d)[0],'truncated');c=compact_raw_response('partial',d)
        self.assertEqual(c['request_payload']['max_tokens'],32000);self.assertEqual(c['finish_reasons'],['length']);self.assertIn('choices',c['full_response'])
if __name__=='__main__':unittest.main()
