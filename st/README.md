My st config and application files

st 0.9.3 (upstream commit 688f70a, cloned to `~/st`) with these official patches from
st.suckless.org, applied in this order:

1. `st-alpha-20240814-a0274bc.diff`: background transparency (`alpha = 0.8`)
2. `st-scrollback-0.9.2.diff`: scrollback history (2000 lines), Shift+PageUp/PageDown
3. `st-scrollback-mouse-0.9.2.diff`: scroll the history with the mouse wheel
4. `st-scrollback-mouse-altscreen-20220127-2c5edf2.diff`: the wheel scrolls the history in
   the shell, but still goes to full-screen programs (less, vim, htop) as before

- `config.h`: my settings (font, colours, alpha, the scrollback key and wheel bindings; 3 lines per wheel step)
- `st.c`: the resulting st.c, for reference

Build: `cd ~/st && git checkout 688f70a -- . && for p in ~/ArchStuff/st/*.diff; do patch -Np1 -i "$p"; done && cp ~/ArchStuff/st/config.h . && make && sudo make install`
