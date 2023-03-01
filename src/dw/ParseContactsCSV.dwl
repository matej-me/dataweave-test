%dw 2.0
input records application/csv
output application/apex
---
records map(record) -> {
 FirstName: record.FirstName,
 LastName: record.LastName,
 Email: record.Email
} as Object {class: "Contact"}