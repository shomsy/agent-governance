import os
import json

schemas_dir = "/home/shomsy/projects/agent-harness/.agents/config/schemas"
os.makedirs(schemas_dir, exist_ok=True)

schemas = [
    "evidence.schema.json",
    "review.schema.json",
    "risk.schema.json",
    "release.schema.json",
    "validation.schema.json",
    "debt.schema.json",
    "status.schema.json"
]

for s in schemas:
    path = os.path.join(schemas_dir, s)
    schema_content = {
        "$schema": "http://json-schema.org/draft-07/schema#",
        "title": s.replace(".schema.json", "").capitalize() + " Schema",
        "type": "object",
        "properties": {
            "id": {"type": "string"},
            "timestamp": {"type": "string", "format": "date-time"},
            "author": {"type": "string"}
        },
        "required": ["id", "timestamp"]
    }
    with open(path, 'w') as f:
        json.dump(schema_content, f, indent=2)

print("Created schemas.")
