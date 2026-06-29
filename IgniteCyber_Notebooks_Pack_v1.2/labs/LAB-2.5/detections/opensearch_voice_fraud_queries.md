# LAB-2.5 OpenSearch Query Starters

Use these as starter pivots. Adapt index names to your local ingest pattern.

## Suspicious caller IDs

```text
caller_id:"+1-202-555-0148" OR case_id:"CJ-VOICE-001"
```

## Callback mismatch

```text
event_type:"callback_mismatch" OR risk_flags:"callback_number_mismatch"
```

## MFA reset after call

```text
case_id:"CJ-VOICE-001" AND event_type:("mfa_reset_requested" OR "mfa_device_rebound")
```

## New device login after MFA reset

```text
case_id:"CJ-VOICE-001" AND event_type:"new_device_login" AND risk_score:>=80
```

## Suspicious domain access after voice contact

```text
case_id:"CJ-VOICE-001" AND (host:"apexfin-helpdesk-login.example" OR url.full:"https://apexfin-helpdesk-login.example/verify")
```

## Case timeline by case_id

```text
case_id:"CJ-VOICE-001"
| sort @timestamp asc
```

## All events related to CJ-VOICE-001

```text
case_id:"CJ-VOICE-001" OR ticket_id:"HD-2025-0619-4451" OR user:"mrivera@apexfin.example" OR source_ip:"203.0.113.45"
```
