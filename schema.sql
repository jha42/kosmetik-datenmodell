-- Kosmetik-Rohstoffverwaltung: Kern des Datenmodells als SQL-Skizze
-- Stand: 02.10.2026
--
-- Vereinfachte Übersetzung eines in der Praxis genutzten Modells, zum Durchdenken
-- und Ausprobieren gedacht. Für MariaDB/MySQL geschrieben. NICHT gegen eine echte
-- Datenbank getestet und ohne Gewähr. Beschreibung und Begründungen: siehe README.md.
-- Absichtlich nur die sieben Kerntabellen. Alles Weitere (Personen, Feedback,
-- Fettsäureprofile, Einkaufsliste, Verpackungen) kann man später ergänzen.

CREATE TABLE rohstoff (
  id                                INT AUTO_INCREMENT PRIMARY KEY,
  name                              VARCHAR(200) NOT NULL,
  inci                              VARCHAR(300),
  dichte                            DECIMAL(5,2),            -- g/ml, zum Umrechnen von ml in g
  haltbarkeit_nach_oeffnung_monate  DECIMAL(4,1)
);

-- Eine gekaufte Packung eines Rohstoffs
CREATE TABLE charge (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  rohstoff_id  INT NOT NULL,
  bestand      DECIMAL(10,2) NOT NULL,                       -- aktueller Restbestand
  mhd          DATE,
  lagerplatz   VARCHAR(100),
  status       ENUM('aktiv','leer','verworfen') NOT NULL DEFAULT 'aktiv',
  FOREIGN KEY (rohstoff_id) REFERENCES rohstoff(id)
);

-- Vorlage: Zutaten in Prozent, in Phasen gegliedert
CREATE TABLE rezept (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  name     VARCHAR(200) NOT NULL,
  version  INT NOT NULL DEFAULT 1
);

CREATE TABLE rezept_phase (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  rezept_id       INT NOT NULL,
  reihenfolge     INT NOT NULL,
  name            VARCHAR(50),                               -- z. B. 'A', 'B'
  arbeitsschritt  TEXT,                                      -- Verarbeitung gehört zur Phase, nicht zum Rohstoff
  FOREIGN KEY (rezept_id) REFERENCES rezept(id)
);

CREATE TABLE rezept_zutat (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  phase_id       INT NOT NULL,
  rohstoff_id    INT NOT NULL,
  menge_prozent  DECIMAL(6,3) NOT NULL,
  FOREIGN KEY (phase_id)    REFERENCES rezept_phase(id),
  FOREIGN KEY (rohstoff_id) REFERENCES rohstoff(id)
);

-- Ein tatsächliches Rühren nach einem Rezept
CREATE TABLE ansatz (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  rezept_id      INT NOT NULL,
  geruehrt_am    DATE,
  batch_gramm    DECIMAL(8,2),                               -- Batchgröße gehört zum Ansatz, nicht zum Rezept
  chargennummer  VARCHAR(30),
  FOREIGN KEY (rezept_id) REFERENCES rezept(id)
);

-- Brücke: Aus welcher Charge wurde wie viel für welchen Ansatz verbraucht?
CREATE TABLE verbrauchsbuchung (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  ansatz_id  INT NOT NULL,
  charge_id  INT NOT NULL,
  menge_g    DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (ansatz_id) REFERENCES ansatz(id),
  FOREIGN KEY (charge_id) REFERENCES charge(id)
);

-- Was sich ausrechnen lässt, wird nicht gespeichert, sondern abgefragt.
-- Beispiel: Gesamtbestand je Rohstoff über alle aktiven Chargen.
CREATE VIEW rohstoff_bestand AS
SELECT r.id, r.name, COALESCE(SUM(c.bestand), 0) AS gesamtbestand
FROM rohstoff r
LEFT JOIN charge c ON c.rohstoff_id = r.id AND c.status = 'aktiv'
GROUP BY r.id, r.name;

-- Beispiel: Prüfsumme je Rezept, soll 100 ergeben.
CREATE VIEW rezept_summe AS
SELECT p.rezept_id, SUM(z.menge_prozent) AS summe_prozent
FROM rezept_phase p
JOIN rezept_zutat z ON z.phase_id = p.id
GROUP BY p.rezept_id;
