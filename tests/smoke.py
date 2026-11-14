#!/usr/bin/env python3
"""Smoke-test a built lv. Pass the executable path as the first argument."""
import os
from pathlib import Path
import subprocess
import sys

exe = Path(sys.argv[1] if len(sys.argv) > 1 else 'src/lv').resolve()
if os.name == 'nt' and exe.suffix != '.exe':
    exe = exe.with_suffix('.exe')
env = os.environ.copy()
env.pop('LV', None)
# Run outside users' config directories; use a clean HOME for deterministic options.
import tempfile
with tempfile.TemporaryDirectory() as tmp:
    env['HOME'] = tmp
    text = '日本語の表示確認\n漢字・ひらがな・カタカナ\n'
    for encoding, option in [('utf-8', '-Iu8'), ('cp932', '-Is'), ('utf-16', '-Iw')]:
        p = subprocess.run([str(exe), option, '-Ou8'], input=text.encode(encoding),
                           capture_output=True, env=env, cwd=tmp)
        assert p.returncode == 0, (encoding, p.stderr)
        assert p.stdout.replace(b'\r\n', b'\n') == text.encode(), (encoding, p.stdout)
        print(encoding + ': PASS')
    p = subprocess.run([str(exe), '-h'], capture_output=True, env=env, cwd=tmp)
    assert p.returncode == 0 and len(p.stdout) > 100 and not p.stderr, p.stderr
    print('help: PASS')
