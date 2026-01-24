#!/usr/bin/env python3
# attempts to locate and run a Flask app inside common locations.
import importlib, sys

CANDIDATES = [
    "kraken_bot.dashboard",
    "kraken_bot.web",
    "kraken_bot.app",
    "kraken_bot.server",
]


def find_app():
    for name in CANDIDATES:
        try:
            m = importlib.import_module(name)
        except Exception:
            continue
        if hasattr(m, "app"):
            return getattr(m, "app"), name
        if hasattr(m, "create_app"):
            try:
                return m.create_app(), name
            except Exception:
                continue
    return None, None


app, src = find_app()
if app is None:
    print("NO_DASHBOARD_APP_FOUND")
    sys.exit(2)
print("RUN_DASHBOARD_FROM=", src)
app.run(host="127.0.0.1", port=8000, debug=False, use_reloader=False, threaded=True)
