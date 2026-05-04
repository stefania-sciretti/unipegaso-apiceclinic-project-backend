-- V114: Seed historical and current appointments for meaningful dashboard results.
-- Covers Dec 2025 – May 2026 (current period) using the 100 patients from V101_1.
--
-- Expected dashboard impact (6m period, Dec 2025 – May 2026):
--   revenueByMonth:     505 → 675 → 1060 → 2180 → 2010 → 600 (growing trend)
--   revenueByArea:      Alimentazione ~2190, Sport ~1160, Clinica ~3380
--   revenueMonth:       ~600 € (May 1-4 COMPLETED)
--   revenuePrevMonth:   ~2010 € (April COMPLETED)
--   activePatients:     ~23 (BOOKED + CONFIRMED in May)
--   newPatients:        4 (registered May 1-4)
--   agendaOccupancy:    ~42% (COMPLETED + CONFIRMED vs total May)
--   cancellationRate:   0% (no CANCELLED added in May)

-- ── Prerequisite check ────────────────────────────────────────────────────────
DO $$
BEGIN
    IF (SELECT COUNT(*) FROM patient WHERE email IN (
        'a.ferrari@gmail.com', 'g.rossi@libero.it',  'f.bianchi@yahoo.it',
        'v.ferrara@libero.it', 's.greco@gmail.com',  'p.lombardi@yahoo.it',
        'c.gatti@gmail.com',   'n.deluca@gmail.com', 'r.gentile@gmail.com',
        'a.moretti@libero.it', 'b.barbieri@yahoo.it','c.fontana@gmail.com',
        'd.santoro@libero.it', 'e.rinaldi@gmail.com','f.caruso@yahoo.it',
        'g.ferrari@gmail.com', 'm.russo@libero.it',  'l.marino@gmail.com'
    )) <> 18 THEN
        RAISE EXCEPTION 'V114: prerequisite check failed – 18 patient emails from V101_1 not found';
    END IF;
END $$;

-- ── 4 new patients registered in May 2026 (populate newPatients KPI) ─────────
INSERT INTO patient (first_name, last_name, fiscal_code, birth_date, email, phone, created_at, updated_at)
VALUES
    ('Marco',   'Pellicini',  'PLLMRC99A01H501A', '1999-01-01', 'marco.pellicini@gmail.com',  '+39 333 1400001', TIMESTAMP '2026-05-01 09:00:00', TIMESTAMP '2026-05-01 09:00:00'),
    ('Sofia',   'Amendola',   'MNDSFX00E41H501B', '2000-05-01', 'sofia.amendola@libero.it',   '+39 347 1400002', TIMESTAMP '2026-05-02 10:00:00', TIMESTAMP '2026-05-02 10:00:00'),
    ('Lorenzo', 'Cavalli',    'CVLLRN01H14F205C', '2001-06-14', 'lorenzo.cavalli@gmail.com',  NULL,              TIMESTAMP '2026-05-03 11:00:00', TIMESTAMP '2026-05-03 11:00:00'),
    ('Giulia',  'Martinetti', 'MRTGLI98M49L219D', '1998-08-09', 'giulia.martinetti@yahoo.it', '+39 366 1400004', TIMESTAMP '2026-05-04 09:00:00', TIMESTAMP '2026-05-04 09:00:00')
ON CONFLICT (fiscal_code) DO NOTHING;

-- ── All appointments ──────────────────────────────────────────────────────────
INSERT INTO appointment (patient_id, specialist_id, scheduled_at, service_type, status, notes, price, created_at, area_id, updated_at)
SELECT
    p.id,
    s.id,
    appt.scheduled_at,
    appt.service_type,
    appt.status,
    appt.notes,
    appt.price,
    appt.scheduled_at - INTERVAL '1 day',
    s.area_id,
    CURRENT_TIMESTAMP
FROM (VALUES

  -- ── December 2025 — 6 COMPLETED (~505 €) ─────────────────────────────────
  ('a.ferrari@gmail.com',   'l.siretta@apiceclinic.it', TIMESTAMP '2025-12-02 09:00:00', 'Seduta di personal training (60 min)',              'COMPLETED', 'Prima sessione valutativa',            50.00::NUMERIC),
  ('g.rossi@libero.it',     's.ruberti@apiceclinic.it', TIMESTAMP '2025-12-04 10:00:00', 'Visita nutrizionale iniziale',                      'COMPLETED', 'Anamnesi alimentare completa',         90.00::NUMERIC),
  ('f.bianchi@yahoo.it',    's.scironi@apiceclinic.it', TIMESTAMP '2025-12-05 08:30:00', 'Visita medico-sportiva',                            'COMPLETED', 'Idoneità sport amatoriale',           120.00::NUMERIC),
  ('m.russo@libero.it',     'c.maratti@apiceclinic.it', TIMESTAMP '2025-12-09 11:00:00', 'Prima visita dietologica',                          'COMPLETED', 'Valutazione composizione corporea',   110.00::NUMERIC),
  ('n.deluca@gmail.com',    'm.lavori@apiceclinic.it',  TIMESTAMP '2025-12-11 14:00:00', 'Seduta di fisioterapia (45 min)',                    'COMPLETED', 'Trattamento cervicalgia',              55.00::NUMERIC),
  ('p.lombardi@yahoo.it',   'l.siretta@apiceclinic.it', TIMESTAMP '2025-12-16 09:00:00', 'Programma di allenamento personalizzato',            'COMPLETED', 'Schema 3 volte a settimana',           80.00::NUMERIC),

  -- ── January 2026 — 8 COMPLETED (~675 €) ──────────────────────────────────
  ('a.ferrari@gmail.com',   's.ruberti@apiceclinic.it', TIMESTAMP '2026-01-07 10:00:00', 'Piano alimentare personalizzato',                   'COMPLETED', 'Dieta ipocalorica strutturata',       120.00::NUMERIC),
  ('g.rossi@libero.it',     'm.lavori@apiceclinic.it',  TIMESTAMP '2026-01-08 14:00:00', 'Valutazione fisioterapica',                         'COMPLETED', 'Valutazione post-trauma ginocchio',    80.00::NUMERIC),
  ('m.russo@libero.it',     'c.maratti@apiceclinic.it', TIMESTAMP '2026-01-09 11:00:00', 'Controllo e aggiornamento piano dietetico',         'COMPLETED', 'Revisione dopo 4 settimane',           70.00::NUMERIC),
  ('f.bianchi@yahoo.it',    'm.lavori@apiceclinic.it',  TIMESTAMP '2026-01-13 14:30:00', 'Trattamento manuale ortopedico',                    'COMPLETED', 'Lombalgia cronica',                    65.00::NUMERIC),
  ('g.ferrari@gmail.com',   's.scironi@apiceclinic.it', TIMESTAMP '2026-01-15 08:00:00', 'Visita medico-sportiva',                            'COMPLETED', 'Idoneità corsa amatoriale',           120.00::NUMERIC),
  ('n.deluca@gmail.com',    'l.siretta@apiceclinic.it', TIMESTAMP '2026-01-20 09:00:00', 'Seduta di personal training (60 min)',              'COMPLETED', 'Allenamento metabolico',               50.00::NUMERIC),
  ('v.ferrara@libero.it',   'c.maratti@apiceclinic.it', TIMESTAMP '2026-01-21 11:00:00', 'Prima visita dietologica',                          'COMPLETED', 'Ipercolesterolemia familiare',        110.00::NUMERIC),
  ('r.gentile@gmail.com',   's.ruberti@apiceclinic.it', TIMESTAMP '2026-01-23 10:00:00', 'Consulenza nutrizionale di follow-up',              'COMPLETED', 'Follow-up piano ottobre',              60.00::NUMERIC),

  -- ── February 2026 — 10 COMPLETED (~1060 €) ───────────────────────────────
  ('a.ferrari@gmail.com',   's.scironi@apiceclinic.it', TIMESTAMP '2026-02-03 08:00:00', 'Visita medico-sportiva',                            'COMPLETED', 'Check-up annuale',                    120.00::NUMERIC),
  ('g.rossi@libero.it',     'c.maratti@apiceclinic.it', TIMESTAMP '2026-02-05 11:00:00', 'Prima visita dietologica',                          'COMPLETED', 'Sindrome metabolica',                 110.00::NUMERIC),
  ('p.lombardi@yahoo.it',   's.ruberti@apiceclinic.it', TIMESTAMP '2026-02-06 10:00:00', 'Piano alimentare personalizzato',                   'COMPLETED', 'Incremento massa muscolare',          120.00::NUMERIC),
  ('m.russo@libero.it',     'm.lavori@apiceclinic.it',  TIMESTAMP '2026-02-10 14:00:00', 'Seduta di fisioterapia (45 min)',                    'COMPLETED', 'Spalla congelata',                     55.00::NUMERIC),
  ('v.ferrara@libero.it',   'l.siretta@apiceclinic.it', TIMESTAMP '2026-02-11 09:00:00', 'Valutazione posturale e funzionale',                'COMPLETED', 'Postura scorretta da lavoro',          70.00::NUMERIC),
  ('s.greco@gmail.com',     's.scironi@apiceclinic.it', TIMESTAMP '2026-02-12 08:00:00', 'Elettrocardiogramma sotto sforzo',                  'COMPLETED', 'Pre-agonistica ciclismo',             200.00::NUMERIC),
  ('c.gatti@gmail.com',     'c.maratti@apiceclinic.it', TIMESTAMP '2026-02-17 11:00:00', 'Piano dietetico per disturbi metabolici',           'COMPLETED', 'Diabete tipo 2 borderline',           150.00::NUMERIC),
  ('r.gentile@gmail.com',   'm.lavori@apiceclinic.it',  TIMESTAMP '2026-02-18 14:00:00', 'Trattamento manuale ortopedico',                    'COMPLETED', 'Epicondilite laterale',                65.00::NUMERIC),
  ('g.ferrari@gmail.com',   's.ruberti@apiceclinic.it', TIMESTAMP '2026-02-19 10:00:00', 'Visita nutrizionale iniziale',                      'COMPLETED', 'Disturbi gastrointestinali',           90.00::NUMERIC),
  ('l.marino@gmail.com',    'l.siretta@apiceclinic.it', TIMESTAMP '2026-02-24 09:30:00', 'Programma di allenamento personalizzato',            'COMPLETED', 'Rientro post-parto',                   80.00::NUMERIC),

  -- ── March 2026 — 14 COMPLETED (~2180 €) ──────────────────────────────────
  ('a.ferrari@gmail.com',   'c.maratti@apiceclinic.it', TIMESTAMP '2026-03-03 11:00:00', 'Controllo e aggiornamento piano dietetico',         'COMPLETED', 'Risultati dopo 8 settimane',           70.00::NUMERIC),
  ('g.rossi@libero.it',     'm.lavori@apiceclinic.it',  TIMESTAMP '2026-03-04 14:00:00', 'Seduta di fisioterapia (45 min)',                    'COMPLETED', 'Riabilitazione ginocchio',             55.00::NUMERIC),
  ('p.lombardi@yahoo.it',   's.scironi@apiceclinic.it', TIMESTAMP '2026-03-05 08:00:00', 'Certificato idoneità sportiva agonistica',          'COMPLETED', 'Maratona di primavera',               150.00::NUMERIC),
  ('m.russo@libero.it',     'l.siretta@apiceclinic.it', TIMESTAMP '2026-03-06 09:00:00', 'Seduta di personal training (60 min)',              'COMPLETED', 'Tonificazione post-dieta',             50.00::NUMERIC),
  ('v.ferrara@libero.it',   's.ruberti@apiceclinic.it', TIMESTAMP '2026-03-10 10:00:00', 'Consulenza nutrizionale di follow-up',              'COMPLETED', 'Ottimi risultati: -3 kg',              60.00::NUMERIC),
  ('s.greco@gmail.com',     'm.lavori@apiceclinic.it',  TIMESTAMP '2026-03-11 14:00:00', 'Ciclo riabilitativo post-operatorio (10 sedute)',   'COMPLETED', 'Post-artroscopia ginocchio',          500.00::NUMERIC),
  ('c.gatti@gmail.com',     's.scironi@apiceclinic.it', TIMESTAMP '2026-03-12 08:30:00', 'Visita medico-sportiva',                            'COMPLETED', 'Idoneità tennis',                     120.00::NUMERIC),
  ('r.gentile@gmail.com',   'c.maratti@apiceclinic.it', TIMESTAMP '2026-03-17 11:00:00', 'Prima visita dietologica',                          'COMPLETED', 'Sovrappeso da stress lavorativo',     110.00::NUMERIC),
  ('g.ferrari@gmail.com',   'm.lavori@apiceclinic.it',  TIMESTAMP '2026-03-18 14:30:00', 'Valutazione fisioterapica',                         'COMPLETED', 'Piede piatto bilaterale',              80.00::NUMERIC),
  ('l.marino@gmail.com',    's.ruberti@apiceclinic.it', TIMESTAMP '2026-03-19 10:00:00', 'Piano alimentare personalizzato',                   'COMPLETED', 'Nutrizione post-parto',               120.00::NUMERIC),
  ('a.moretti@libero.it',   'l.siretta@apiceclinic.it', TIMESTAMP '2026-03-24 09:00:00', 'Pacchetto 10 sedute personal training',             'COMPLETED', 'Programma forza 3 mesi',              450.00::NUMERIC),
  ('b.barbieri@yahoo.it',   's.scironi@apiceclinic.it', TIMESTAMP '2026-03-25 08:00:00', 'Elettrocardiogramma sotto sforzo',                  'COMPLETED', 'Pre-agonistica calcio',               200.00::NUMERIC),
  ('c.fontana@gmail.com',   'c.maratti@apiceclinic.it', TIMESTAMP '2026-03-26 11:00:00', 'Piano dietetico per disturbi metabolici',           'COMPLETED', 'Tiroidite di Hashimoto',              150.00::NUMERIC),
  ('d.santoro@libero.it',   'm.lavori@apiceclinic.it',  TIMESTAMP '2026-03-27 14:00:00', 'Trattamento manuale ortopedico',                    'COMPLETED', 'Colpo di frusta post-incidente',       65.00::NUMERIC),

  -- ── April 2026 — 16 COMPLETED (~2010 €) — becomes revenuePrevMonth ───────
  ('a.ferrari@gmail.com',   'm.lavori@apiceclinic.it',  TIMESTAMP '2026-04-01 14:00:00', 'Seduta di fisioterapia (45 min)',                    'COMPLETED', 'Follow-up spalla',                     55.00::NUMERIC),
  ('g.rossi@libero.it',     's.ruberti@apiceclinic.it', TIMESTAMP '2026-04-02 10:00:00', 'Piano alimentare personalizzato',                   'COMPLETED', 'Revisione obiettivi Q2',              120.00::NUMERIC),
  ('p.lombardi@yahoo.it',   'c.maratti@apiceclinic.it', TIMESTAMP '2026-04-03 11:00:00', 'Controllo e aggiornamento piano dietetico',         'COMPLETED', 'Perdita 5 kg in 2 mesi',               70.00::NUMERIC),
  ('m.russo@libero.it',     's.scironi@apiceclinic.it', TIMESTAMP '2026-04-07 08:00:00', 'Visita medico-sportiva',                            'COMPLETED', 'Rientro attività dopo parto',         120.00::NUMERIC),
  ('v.ferrara@libero.it',   'l.siretta@apiceclinic.it', TIMESTAMP '2026-04-08 09:00:00', 'Programma di allenamento personalizzato',            'COMPLETED', 'Preparazione mezza maratona',          80.00::NUMERIC),
  ('s.greco@gmail.com',     's.ruberti@apiceclinic.it', TIMESTAMP '2026-04-09 10:00:00', 'Visita nutrizionale iniziale',                      'COMPLETED', 'Integrazione sportiva ciclismo',       90.00::NUMERIC),
  ('c.gatti@gmail.com',     'm.lavori@apiceclinic.it',  TIMESTAMP '2026-04-14 14:00:00', 'Ciclo riabilitativo post-operatorio (10 sedute)',   'COMPLETED', 'Riabilitazione protesi anca',         500.00::NUMERIC),
  ('r.gentile@gmail.com',   's.scironi@apiceclinic.it', TIMESTAMP '2026-04-15 08:30:00', 'Certificato idoneità sportiva agonistica',          'COMPLETED', 'Gara ciclismo regionale',             150.00::NUMERIC),
  ('g.ferrari@gmail.com',   'c.maratti@apiceclinic.it', TIMESTAMP '2026-04-16 11:00:00', 'Prima visita dietologica',                          'COMPLETED', 'Dieta per celiachia',                 110.00::NUMERIC),
  ('l.marino@gmail.com',    'l.siretta@apiceclinic.it', TIMESTAMP '2026-04-17 09:00:00', 'Valutazione posturale e funzionale',                'COMPLETED', 'Valutazione 6 mesi post-parto',        70.00::NUMERIC),
  ('a.moretti@libero.it',   's.ruberti@apiceclinic.it', TIMESTAMP '2026-04-21 10:00:00', 'Piano alimentare personalizzato',                   'COMPLETED', 'Piano carico carboidrati pre-gara',   120.00::NUMERIC),
  ('b.barbieri@yahoo.it',   'm.lavori@apiceclinic.it',  TIMESTAMP '2026-04-22 14:00:00', 'Trattamento manuale ortopedico',                    'COMPLETED', 'Distorsione caviglia recidivante',     65.00::NUMERIC),
  ('c.fontana@gmail.com',   's.scironi@apiceclinic.it', TIMESTAMP '2026-04-23 08:00:00', 'Elettrocardiogramma sotto sforzo',                  'COMPLETED', 'Pre-agonistica triathlon',            200.00::NUMERIC),
  ('d.santoro@libero.it',   'c.maratti@apiceclinic.it', TIMESTAMP '2026-04-24 11:00:00', 'Piano dietetico per disturbi metabolici',           'COMPLETED', 'Gestione peso pre-intervento',        150.00::NUMERIC),
  ('e.rinaldi@gmail.com',   'l.siretta@apiceclinic.it', TIMESTAMP '2026-04-28 09:00:00', 'Seduta di personal training (60 min)',              'COMPLETED', 'Inizio percorso fitness',              50.00::NUMERIC),
  ('f.caruso@yahoo.it',     's.ruberti@apiceclinic.it', TIMESTAMP '2026-04-29 10:00:00', 'Consulenza nutrizionale di follow-up',              'COMPLETED', 'Verifica bilancio calorico',           60.00::NUMERIC),

  -- ── May 2026 days 1-4 — COMPLETED (~600 €) — becomes revenueMonth ─────────
  ('a.ferrari@gmail.com',   'l.siretta@apiceclinic.it', TIMESTAMP '2026-05-01 09:00:00', 'Seduta di personal training (60 min)',              'COMPLETED', 'Sessione cardio-forza',                50.00::NUMERIC),
  ('g.rossi@libero.it',     's.scironi@apiceclinic.it', TIMESTAMP '2026-05-01 08:00:00', 'Visita medico-sportiva',                            'COMPLETED', 'Idoneità nuoto masters',              120.00::NUMERIC),
  ('p.lombardi@yahoo.it',   'm.lavori@apiceclinic.it',  TIMESTAMP '2026-05-02 14:00:00', 'Seduta di fisioterapia (45 min)',                    'COMPLETED', 'Mantenimento post-ciclo',              55.00::NUMERIC),
  ('m.russo@libero.it',     's.ruberti@apiceclinic.it', TIMESTAMP '2026-05-02 10:00:00', 'Piano alimentare personalizzato',                   'COMPLETED', 'Riformulazione piano primavera',      120.00::NUMERIC),
  ('v.ferrara@libero.it',   'c.maratti@apiceclinic.it', TIMESTAMP '2026-05-03 11:00:00', 'Prima visita dietologica',                          'COMPLETED', 'Nuova paziente da referral',          110.00::NUMERIC),
  ('s.greco@gmail.com',     'm.lavori@apiceclinic.it',  TIMESTAMP '2026-05-04 14:00:00', 'Trattamento manuale ortopedico',                    'COMPLETED', 'Seduta di mantenimento',               65.00::NUMERIC),
  ('c.gatti@gmail.com',     'l.siretta@apiceclinic.it', TIMESTAMP '2026-05-04 09:00:00', 'Programma di allenamento personalizzato',            'COMPLETED', 'Aggiornamento programma forza',        80.00::NUMERIC),

  -- ── May 2026 days 5-31 — CONFIRMED (agendaOccupancy + activePatients) ──────
  ('a.ferrari@gmail.com',   's.ruberti@apiceclinic.it', TIMESTAMP '2026-05-07 10:30:00', 'Consulenza nutrizionale di follow-up',              'CONFIRMED', 'Follow-up piano maggio',               60.00::NUMERIC),
  ('g.rossi@libero.it',     'c.maratti@apiceclinic.it', TIMESTAMP '2026-05-08 10:00:00', 'Controllo e aggiornamento piano dietetico',         'CONFIRMED', 'Check mensile dieta',                  70.00::NUMERIC),
  ('p.lombardi@yahoo.it',   's.scironi@apiceclinic.it', TIMESTAMP '2026-05-11 08:00:00', 'Certificato idoneità sportiva agonistica',          'CONFIRMED', 'Gara maggio',                         150.00::NUMERIC),
  ('m.russo@libero.it',     'm.lavori@apiceclinic.it',  TIMESTAMP '2026-05-12 09:00:00', 'Ciclo riabilitativo post-operatorio (10 sedute)',   'CONFIRMED', 'Avvio ciclo riabilitativo',           500.00::NUMERIC),
  ('v.ferrara@libero.it',   'l.siretta@apiceclinic.it', TIMESTAMP '2026-05-15 09:30:00', 'Valutazione posturale e funzionale',                'CONFIRMED', 'Seconda valutazione',                  70.00::NUMERIC),
  ('s.greco@gmail.com',     'c.maratti@apiceclinic.it', TIMESTAMP '2026-05-18 11:00:00', 'Piano dietetico per disturbi metabolici',           'CONFIRMED', NULL,                                  150.00::NUMERIC),
  ('c.gatti@gmail.com',     'm.lavori@apiceclinic.it',  TIMESTAMP '2026-05-19 09:30:00', 'Valutazione fisioterapica',                         'CONFIRMED', 'Verifica post-ciclo riabilitativo',    80.00::NUMERIC),
  ('r.gentile@gmail.com',   's.scironi@apiceclinic.it', TIMESTAMP '2026-05-25 08:30:00', 'Visita medico-sportiva',                            'CONFIRMED', 'Preparazione stagione estiva',        120.00::NUMERIC),

  -- ── May 2026 — BOOKED (first appointments for 4 new patients) ────────────
  ('marco.pellicini@gmail.com',  'l.siretta@apiceclinic.it', TIMESTAMP '2026-05-06 09:00:00', 'Valutazione posturale e funzionale',  'BOOKED', 'Primo accesso',                70.00::NUMERIC),
  ('sofia.amendola@libero.it',   'c.maratti@apiceclinic.it', TIMESTAMP '2026-05-09 11:00:00', 'Prima visita dietologica',            'BOOKED', 'Referral medico di base',      110.00::NUMERIC),
  ('lorenzo.cavalli@gmail.com',  's.scironi@apiceclinic.it', TIMESTAMP '2026-05-10 08:00:00', 'Visita medico-sportiva',              'BOOKED', 'Idoneità calcio dilettanti',   120.00::NUMERIC),
  ('giulia.martinetti@yahoo.it', 's.ruberti@apiceclinic.it', TIMESTAMP '2026-05-16 10:00:00', 'Visita nutrizionale iniziale',        'BOOKED', 'Disturbi alimentari lievi',     90.00::NUMERIC)

) AS appt(patient_email, specialist_email, scheduled_at, service_type, status, notes, price)
JOIN patient    p ON p.email = appt.patient_email
JOIN specialist s ON s.email = appt.specialist_email;
