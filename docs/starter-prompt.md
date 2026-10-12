# Starter-Prompt: eigene lokale Lösung auf einem Windows-PC

Stand: 12.10.2026 · Vorschlag, nicht getestet auf einem frischen Windows-Rechner

Dieser Prompt ist gedacht für alle, die das Datenmodell aus diesem Repo für sich selbst
nutzen wollen, ohne Server und ohne Cloud, nur auf einem einzelnen Windows-PC. Man gibt ihn
einer KI mit Dateizugriff (z. B. Claude Code) in einem leeren Projektordner.

## Vorbereitung (vorab, von Hand)

- Einen leeren Ordner für das Projekt anlegen, z. B. in den Dokumenten.
- Python installieren und ein KI-Werkzeug mit Dateizugriff einrichten. Die aktuellen
  Installationsanleitungen stehen bei den jeweiligen Anbietern; die Schritte ändern sich,
  deshalb stehen sie hier nicht.
- Den Prompt unten kopieren und als erste Nachricht einfügen.

## Der Prompt

```
Ich möchte eine Verwaltung für meine Naturkosmetik-Rohstoffe, Rezepte und Ansätze bauen,
komplett lokal auf meinem Windows-PC. Ich bin keine Programmiererin; du schreibst und
erklärst, ich entscheide und teste.

Als Vorlage dient dieses öffentliche Repo: https://github.com/jha42/kosmetik-datenmodell
Bitte lies zuerst README.md (Grundideen, Tabellen, Entwurfsentscheidungen), schema.sql
(ungetestete SQL-Skizze) und docs/lehren.md (Erfahrungen und Regeln). Übernimm die Ideen,
nicht blind den Aufbau.

Randbedingungen
- Alles läuft lokal auf diesem Windows-PC, keine Cloud, keine Server, kein Docker.
- Datenbank: SQLite (eine einzelne Datei). Wenn du etwas anderes für klüger hältst,
  begründe es kurz, bevor du es nimmst.
- Oberfläche: kleine lokale Webseite (Python, z.B. Flask), im Browser unter localhost,
  Start per Doppelklick auf eine .bat-Datei.
- Installationsschritte für Windows bitte einzeln und mit genauen Klicks/Befehlen erklären.
- Vor jeder Sitzung, in der du die Datenbank änderst, eine Sicherungskopie der Datei
  anlegen (Datum im Dateinamen). Nie ohne Rückfrage Daten löschen.

Ziele in dieser Reihenfolge (nach jedem Schritt anhalten, ich teste)
1. Schema aus dem Repo für SQLite anpassen und gegen eine echte Datenbank testen.
2. Rohstoffe und Chargen erfassen (zuerst per Formular/Import, MHD und Bestand).
3. Rezepte in Prozent mit Phasen, Zutaten und Arbeitsschritten.
4. Ansatz anlegen (Rezept + Batchgröße), Verprobung "reicht der Bestand?".
5. Druckbarer Rührzettel (Phasen, Reihenfolge, Gramm-Mengen, Checkboxen auf Papier).
6. Verbrauch von den Chargen abbuchen, älteste/abgelaufene Ware zuletzt.

Arbeitsstil
- Kleine Schritte, immer erst sagen, was du vorhast, dann bauen.
- Bei fachlichen Fragen (Rezeptur, Konservierung, Dosierung) nicht raten: nachfragen,
  Quellen nennen, Unsicherheit offen sagen. Arbeitsschritte eines Rezepts nie erfinden.
- Wenn ich Vorschläge mache, wäge Vor- und Nachteile ab, statt nur zuzustimmen.
- Lege eine Datei CLAUDE.md im Projektordner an und trage dort die Regeln und
  Entscheidungen ein, auf die wir uns einigen, damit sie in jeder Sitzung gelten.
- Jede neue Seite testest du gegen alle vorhandenen Datensätze, bevor du sagst, sie sei fertig.

Meine Daten und Gewohnheiten (bitte frag mich danach, bevor du etwas annimmst)
- Wie viele Rohstoffe habe ich ungefähr, und in welcher Form liegen sie vor?
- Welche Rezeptquellen nutze ich?
- Rühre ich Seifen, Emulsionen, Öle, Hydrolate? Welche Batchgrößen?
```

## Warum so

- **SQLite statt Datenbankserver:** Eine Datei, kein Dienst, Sicherung = Datei kopieren. Für
  eine Person an einem Rechner reicht das. Mehrere Geräte oder Personen sprechen für eine
  richtige Datenbank.
- **Sicherungskopie vor jeder Sitzung:** SQLite kennt keine getrennten Konten. Die KI kann
  also auch löschen; die Kopie ersetzt die Rechtetrennung.
- **Reihenfolge der Ziele:** Erst muss das Datenmodell stimmen, dann kommen Oberfläche und
  Abbuchen. Das spiegelt die Reihenfolge, in der das Original gewachsen ist.
- **Nachfragen statt Erfinden bei Arbeitsschritten:** Ohne diese Regel füllt die KI
  Rezepte gern mit plausibel klingenden, aber erfundenen Verarbeitungsschritten auf.
