import {readFileSync} from 'node:fs';
import {resolve} from 'node:path';

const root=resolve(process.cwd(),'games');
const files=['index.html','retro-flight.html','backgammon.html'];
for(const f of files){const p=resolve(root,f);const s=readFileSync(p,'utf8');
  if(!s.toLowerCase().includes('<!doctype html>')) throw new Error(`${f}: missing doctype`);
  if(!/<html[\s>]/i.test(s)||!/<\/html>/i.test(s)) throw new Error(`${f}: invalid html shell`);
}
const flight=readFileSync(resolve(root,'retro-flight.html'),'utf8');
for(const token of ['id="score"','id="hiscore"','id="fuel"','id="fuelbar"','id="go"','id="left"','id="right"','localStorage','Telegram?.WebApp'])
  if(!flight.includes(token)) throw new Error(`retro-flight.html: missing ${token}`);
const bg=readFileSync(resolve(root,'backgammon.html'),'utf8');
for(const token of ['99fk.github.io/backgammon-html/bg-online.html','Telegram?.WebApp','Bear-off','Bar'])
  if(!bg.includes(token)) throw new Error(`backgammon.html: missing ${token}`);
const index=readFileSync(resolve(root,'index.html'),'utf8');
for(const token of ['./retro-flight.html','./backgammon.html'])
  if(!index.includes(token)) throw new Error(`index.html: missing ${token}`);
console.log('Simorgh games smoke tests: PASS');
