CREATE TABLE lexicontable(word TEXT NOT NULL, romanization TEXT NOT NULL, shortcut INTEGER NOT NULL, ping INTEGER NOT NULL);
.mode tabs
.import lexicon.txt lexicontable
CREATE INDEX lexiconwordindex ON lexicontable(word);
CREATE INDEX lexiconshortcutindex ON lexicontable(shortcut);
CREATE INDEX lexiconpingindex ON lexicontable(ping);

CREATE TABLE t2stable(traditional INTEGER NOT NULL PRIMARY KEY, simplified TEXT NOT NULL);
.import t2s.txt t2stable

CREATE TABLE composetable(word TEXT NOT NULL, romanization TEXT NOT NULL, ping INTEGER NOT NULL);
.import compose.txt composetable
CREATE INDEX composepingindex ON composetable(ping);

CREATE TABLE pinyintable(word TEXT NOT NULL, shortcut INTEGER NOT NULL, pin INTEGER NOT NULL);
.import pinyin.txt pinyintable
CREATE INDEX pinyinshortcutindex ON pinyintable(shortcut);
CREATE INDEX pinyinpinindex ON pinyintable(pin);

CREATE TABLE shapetable(word TEXT NOT NULL, cangjie TEXT NOT NULL, stroke TEXT NOT NULL);
.import shape.txt shapetable
CREATE INDEX shapecangjieindex ON shapetable(cangjie);
CREATE INDEX shapestrokeindex ON shapetable(stroke);

CREATE TABLE symboltable(category INTEGER NOT NULL, codepoint TEXT NOT NULL, cantonese TEXT NOT NULL, romanization TEXT NOT NULL, shortcut INTEGER NOT NULL, ping INTEGER NOT NULL);
.import symbol.txt symboltable
CREATE INDEX symbolshortcutindex ON symboltable(shortcut);
CREATE INDEX symbolpingindex ON symboltable(ping);
