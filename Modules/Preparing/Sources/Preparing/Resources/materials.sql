CREATE TABLE jyutpingtable(word TEXT NOT NULL, romanization TEXT NOT NULL);
.mode tabs
.import jyutping.txt jyutpingtable
CREATE INDEX jyutpingwordindex ON jyutpingtable(word);

CREATE TABLE yingwaatable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, pronunciation TEXT NOT NULL, pronunciationmark TEXT NOT NULL, interpretation TEXT NOT NULL);
.import yingwaa.txt yingwaatable
CREATE INDEX yingwaacodeindex ON yingwaatable(code);

CREATE TABLE chohoktable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, tone TEXT NOT NULL, faancit TEXT NOT NULL);
.import chohok.txt chohoktable
CREATE INDEX chohokcodeindex ON chohoktable(code);

CREATE TABLE fanwantable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, yamyeung TEXT NOT NULL, tone TEXT NOT NULL, rhyme TEXT NOT NULL, interpretation TEXT NOT NULL);
.import fanwan.txt fanwantable
CREATE INDEX fanwancodeindex ON fanwantable(code);

CREATE TABLE gwongwantable(code INTEGER NOT NULL, word TEXT NOT NULL, rhyme TEXT NOT NULL, subrhyme TEXT NOT NULL, subrhymeserial INTEGER NOT NULL, subrhymenumber INTEGER NOT NULL, upper TEXT NOT NULL, lower TEXT NOT NULL, initial TEXT NOT NULL, rounding TEXT NOT NULL, division TEXT NOT NULL, rhymeclass TEXT NOT NULL, repeating TEXT NOT NULL, tone TEXT NOT NULL, interpretation TEXT NOT NULL);
.mode csv
.import gwongwan.txt gwongwantable
CREATE INDEX gwongwancodeindex ON gwongwantable(code);
