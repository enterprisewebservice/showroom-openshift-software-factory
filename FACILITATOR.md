# Facilitator guide — The OpenShift Software Factory

Instructor-only material. This file lives at the repo root and is **never
built into the attendee Showroom** (Antora builds `content/` only). Every
command here assumes a **platform-admin session** — not a seat terminal;
seat identities are denied these calls by design, and Module 3 has
attendees prove that themselves.

## Module 3 — the audit-line demo (shared screen)

The attendee arc ends with them generating an audit record they cannot
read. The room payoff is you showing it land.

1. Have attendees send their agent the exercise prompt (the latest-commit
   question) in Mattermost.
2. On the shared screen, from an admin session:

   ```bash
   oc logs deploy/mcp-gateway-data-science-gateway-class -n agent-office --since=2m | grep "POST /mcp"
   ```

   Within moments of an agent's reply, a new Envoy access-log line lands:

   ```
   [2026-08-22T20:05:04.205Z] "POST /mcp HTTP/1.1" 200 - via_upstream ...
   ```

   Talking point: `200` is the gateway authorizing and forwarding the call
   their message caused; a `403` would be a refusal. The room just watched
   tenants generate audit records they cannot read, into a stream only the
   platform can.

Testing solo: run the log command from a second terminal logged in as the
cluster admin. The Showroom terminal is a seat and will keep answering
`Forbidden` — correctly.

Honest gap, if asked: a per-seat audit view (each tenant reading only its
own lines) does not exist — Red Hat Connectivity Link's access log is
per-gateway, not per-caller. It is a named product-ask in Module 8's gap
map, alongside per-caller credential injection.

## Module 3 — on-demand credential refresh (optional live beat)

Seat access tokens self-expire hourly; the platform refresher re-mints
them every 30 minutes and delivery is hot-reload (no pod movement). To
demonstrate a refresh without waiting for the half-hour tick:

```bash
oc create job --from=cronjob/seat-gitea-token-refresher -n gitea refresh-demo-$(date +%s)
```

Attendees watching `oc get pods -n <seat>-agent-workspace -w` see nothing
move — same pod, `RESTARTS 0` — while `gitea_get_me` keeps answering as
their user across the token boundary. That non-event is the demo.

## Module 2 — timing expectations

The automated sync lands ~11 seconds after a merge; the operator re-renders
the agent identity in place ~20 seconds later (no pod restart). Attendees
verify by evidence (Application History, `oc` spec readback), not by
watching for spinners. A chat thread may echo its old style for a turn or
two after a rollback (history momentum) — `/new` in the agent's channel is
the deterministic reset, available on workshop seats only.

## Content pushes during a session

The single shared Showroom instance rebuilds its whole site on every
content change: the route 503s for ~60 seconds per push (Recreate
strategy; the terminal home PVC is RWO). Freeze content during live
modules, or announce the refresh.
