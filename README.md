# ApiceClinic — Backend

REST API per la gestione di una clinica sportiva. Sviluppata con **Kotlin + Spring Boot 3** e autenticazione JWT.

---

## Tecnologie

| Layer | Tecnologia |
|---|---|
| Language | Kotlin 2.1.20 |
| Framework | Spring Boot 3.2.3 |
| Database | PostgreSQL 14+ |
| Migrations | Flyway |
| Security | Spring Security + JWT (jjwt 0.12) |
| Docs | SpringDoc OpenAPI (Swagger UI) |
| Build | Maven 3.8+ |

---

## Prerequisiti

- **JDK 21**
- **Maven 3.8+**
- **PostgreSQL 14+** in esecuzione su `localhost:5432`

Crea il database prima di avviare:
```sql
CREATE DATABASE apiceclinic;
```

---

## Configurazione

Il profilo attivo di default è **`dev`**. Le variabili di ambiente hanno la precedenza sui valori di default.

| Variabile | Default |
|---|---|
| `DATABASE_URL` | `jdbc:postgresql://localhost:5432/apiceclinic` |
| `DATABASE_USERNAME` | `postgres` |
| `DATABASE_PASSWORD` | `password` |
| `JWT_SECRET` | `ApiceClinicSecretKeyForJWTTokenGenerationMinimum256BitsRequired1234567` |
| `JWT_EXPIRATION` | `86400000` (24h, in ms) |

---

## Avvio

```bash
mvn spring-boot:run -pl apiceclinic-module/clinic
```

Al primo avvio (profilo `dev`) Flyway applica tutte le migrazioni e **DataInitializer** crea gli utenti di default.

---

## Credenziali di accesso

### Admin
```
username: admin
password: admin123
role:     ROLE_ADMIN
```

### Utente standard
```
username: user
password: user123
role:     ROLE_USER
```

---

## Documentazione API

Swagger UI disponibile a runtime su `http://localhost:8080/swagger-ui.html`  
OpenAPI JSON: `http://localhost:8080/v3/api-docs`

### Endpoint implementati

> 🔓 = pubblico · 🔒 = richiede JWT Bearer token

#### Auth
| Metodo | Path | Descrizione |
|--------|------|-------------|
| `POST` | `/api/auth/register` | 🔓 Registra nuovo paziente + account |
| `POST` | `/api/auth/login` | 🔓 Login — restituisce JWT |
| `GET`  | `/api/auth/validate` | 🔓 Valida un JWT token |

#### Pazienti
| Metodo | Path | Descrizione |
|--------|------|-------------|
| `GET`    | `/api/patients` | 🔒 Lista pazienti (`?search=`) |
| `POST`   | `/api/patients` | 🔒 Crea paziente |
| `GET`    | `/api/patients/{id}` | 🔒 Dettaglio paziente |
| `PUT`    | `/api/patients/{id}` | 🔒 Aggiorna paziente |
| `DELETE` | `/api/patients/{id}` | 🔒 Elimina paziente |

#### Specialisti
| Metodo | Path | Descrizione |
|--------|------|-------------|
| `GET`    | `/api/specialists` | 🔒 Lista specialisti (`?role=`) |
| `POST`   | `/api/specialists` | 🔒 Crea specialista |
| `GET`    | `/api/specialists/{id}` | 🔒 Dettaglio specialista |
| `PUT`    | `/api/specialists/{id}` | 🔒 Aggiorna specialista |
| `DELETE` | `/api/specialists/{id}` | 🔒 Elimina specialista |

#### Appuntamenti
| Metodo | Path | Descrizione |
|--------|------|-------------|
| `GET`    | `/api/appointments` | 🔒 Lista appuntamenti (`?patientId`, `?specialistId`, `?status`) |
| `POST`   | `/api/appointments` | 🔒 Prenota appuntamento |
| `GET`    | `/api/appointments/{id}` | 🔒 Dettaglio appuntamento |
| `PUT`    | `/api/appointments/{id}/status` | 🔒 Aggiorna stato |
| `DELETE` | `/api/appointments/{id}` | 🔒 Cancella appuntamento (soft) |

#### Referti
| Metodo | Path | Descrizione |
|--------|------|-------------|
| `GET`  | `/api/reports` | 🔒 Lista referti |
| `POST` | `/api/reports` | 🔒 Crea referto (appuntamento COMPLETED) |
| `GET`  | `/api/reports/{id}` | 🔒 Dettaglio referto |
| `PUT`  | `/api/reports/{id}` | 🔒 Aggiorna referto |
| `GET`  | `/api/reports/appointment/{appointmentId}` | 🔒 Referto per appuntamento |

#### Piani dietetici
| Metodo | Path | Descrizione |
|--------|------|-------------|
| `GET`    | `/api/diet-plans` | 🔒 Lista piani (`?patientId`) |
| `POST`   | `/api/diet-plans` | 🔒 Crea piano dietetico |
| `GET`    | `/api/diet-plans/{id}` | 🔒 Dettaglio piano |
| `PUT`    | `/api/diet-plans/{id}` | 🔒 Aggiorna piano |
| `DELETE` | `/api/diet-plans/{id}` | 🔒 Elimina piano |

#### Piani di allenamento
| Metodo | Path | Descrizione |
|--------|------|-------------|
| `GET`    | `/api/training-plans` | 🔒 Lista piani (`?patientId`) |
| `POST`   | `/api/training-plans` | 🔒 Crea piano di allenamento |
| `GET`    | `/api/training-plans/{id}` | 🔒 Dettaglio piano |
| `PUT`    | `/api/training-plans/{id}` | 🔒 Aggiorna piano |
| `DELETE` | `/api/training-plans/{id}` | 🔒 Elimina piano |

#### Misurazioni glicemia
| Metodo | Path | Descrizione |
|--------|------|-------------|
| `GET`    | `/api/glycemia-measurements` | 🔒 Lista misurazioni (`?patientId`) |
| `POST`   | `/api/glycemia-measurements` | 🔒 Registra misurazione |
| `GET`    | `/api/glycemia-measurements/{id}` | 🔒 Dettaglio misurazione |
| `PUT`    | `/api/glycemia-measurements/{id}` | 🔒 Aggiorna misurazione |
| `DELETE` | `/api/glycemia-measurements/{id}` | 🔒 Elimina misurazione |
| `GET`    | `/api/glycemia-measurements/classification-rules` | 🔒 Regole classificazione ADA/WHO |

#### Ricette
| Metodo | Path | Descrizione |
|--------|------|-------------|
| `GET`    | `/api/recipes` | 🔒 Lista ricette (`?category`, `?search`) |
| `POST`   | `/api/recipes` | 🔒 Crea ricetta |
| `GET`    | `/api/recipes/{id}` | 🔒 Dettaglio ricetta |
| `PUT`    | `/api/recipes/{id}` | 🔒 Aggiorna ricetta |
| `DELETE` | `/api/recipes/{id}` | 🔒 Elimina ricetta |

#### Servizi
| Metodo | Path | Descrizione |
|--------|------|-------------|
| `GET`    | `/api/services` | 🔒 Lista servizi (`?specialistId`) |
| `POST`   | `/api/services` | 🔒 Crea servizio |
| `GET`    | `/api/services/{id}` | 🔒 Dettaglio servizio |
| `PUT`    | `/api/services/{id}` | 🔒 Aggiorna servizio |
| `DELETE` | `/api/services/{id}` | 🔒 Elimina servizio |

#### Dashboard
| Metodo | Path | Descrizione |
|--------|------|-------------|
| `GET` | `/api/dashboard` | 🔒 Statistiche aggregate (`?period=6m`) |

---

## Schema ER

```mermaid
erDiagram
    patient {
        bigint id PK
        varchar first_name
        varchar last_name
        varchar fiscal_code UK
        date birth_date
        varchar email
        varchar phone
        timestamp created_at
        timestamp updated_at
    }
    areas {
        bigint id PK
        varchar name
    }
    specialist {
        bigint id PK
        varchar first_name
        varchar last_name
        varchar role
        text bio
        varchar email UK
        bigint area_id FK
        timestamp created_at
        timestamp updated_at
    }
    appointment {
        bigint id PK
        bigint patient_id FK
        bigint specialist_id FK
        timestamp scheduled_at
        varchar visit_type
        varchar status
        text notes
        numeric price
        timestamp updated_at
    }
    report {
        bigint id PK
        bigint appointment_id FK
        date issued_date
        text diagnosis
        text prescription
        text specialist_notes
        timestamp created_at
        timestamp updated_at
    }
    diet_plan {
        bigint id PK
        bigint patient_id FK
        bigint specialist_id FK
        varchar title
        text description
        int calories
        int duration_weeks
        boolean active
        timestamp created_at
        timestamp updated_at
    }
    training_plan {
        bigint id PK
        bigint patient_id FK
        bigint specialist_id FK
        varchar title
        text description
        int weeks
        int sessions_per_week
        boolean active
        timestamp created_at
        timestamp updated_at
    }
    glycemia_measurement {
        bigint id PK
        bigint patient_id FK
        bigint specialist_id FK
        timestamp measured_at
        int value_mg_dl
        varchar context
        text notes
        timestamp created_at
        timestamp updated_at
    }
    services {
        bigint id PK
        varchar service
        numeric price
        bigint specialist_id FK
        bigint area_id FK
    }
    recipe {
        bigint id PK
        varchar title
        text description
        text ingredients
        text instructions
        int calories
        varchar category
        timestamp created_at
        timestamp updated_at
    }
    users {
        bigint id PK
        varchar username UK
        varchar password
        varchar email
        varchar role
        boolean enabled
        bigint patient_id FK
        timestamp created_at
        timestamp updated_at
    }

    areas        ||--o{ specialist          : "groups"
    areas        ||--o{ services            : "categorizes"
    patient      ||--o{ appointment         : "books"
    specialist   ||--o{ appointment         : "manages"
    appointment  ||--o| report              : "generates"
    patient      ||--o{ diet_plan           : "follows"
    specialist   ||--o{ diet_plan           : "assigns"
    patient      ||--o{ training_plan       : "follows"
    specialist   ||--o{ training_plan       : "assigns"
    patient      ||--o{ glycemia_measurement: "has"
    specialist   ||--o{ glycemia_measurement: "records"
    specialist   ||--o{ services            : "offers"
    patient      ||--o| users               : "linked to"
```

