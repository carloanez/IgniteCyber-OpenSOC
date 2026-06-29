# Elastic Validation Query Seeds

Use these queries to validate that promoted MISP indicators are evidence-backed before setting `to_ids=true`.

## mshta scriptlet execution

```kql
process.name : "mshta.exe" and process.command_line : "*GetObject*script*mshta.sct*"
```

## BITSAdmin download

```kql
process.name : "bitsadmin.exe" and process.command_line : "*/transfer*Download*"
```

## PowerShell encoded or hidden execution

```kql
process.name : "powershell.exe" and process.command_line : ("*-enc*" or "*-EncodedCommand*" or "*-W Hidden*")
```

## C2-like pixel beacon

```kql
url.path : "/pixel.gif" or url.full : "*pixel.gif*"
```

## Scheduled task artifact

```kql
process.command_line : "*schtasks*" or registry.path : "*Schedule*TaskCache*"
```

## Log4Shell JNDI marker

```kql
http.request.headers.user_agent : "*${jndi:*" or message : "*jndi:ldap*"
```
