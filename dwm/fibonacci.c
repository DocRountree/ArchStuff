/*
 * fibonacci layouts (spiral and dwindle) with gaps.
 *
 * Each window takes part of the remaining area and hands the rest on:
 * the master takes mfact of the width, every later window half of what is
 * left, alternating vertical and horizontal splits. Spiral rotates the side
 * each window takes (left, top, right, bottom); dwindle always takes the
 * left/top part. Splits are exact (the rest gets any odd pixel), and like
 * tile() there is gappx between windows and from every screen edge.
 */
void
fibonacci(Monitor *mon, int s) {
	unsigned int i, n, g = mon->gappx;
	int x, y, w, h, cw, ch, cx, cy, split = 1;
	Client *c;

	for(n = 0, c = nexttiled(mon->clients); c; c = nexttiled(c->next), n++);
	if(n == 0)
		return;

	/* remaining area, laid out without its left/top gap; every cell then
	 * gives up one gap on its right and bottom */
	x = mon->wx + g;
	y = mon->wy + g;
	w = mon->ww - g;
	h = mon->wh - g;

	for(i = 0, c = nexttiled(mon->clients); c; c = nexttiled(c->next), i++) {
		cx = x; cy = y; cw = w; ch = h;
		if(split && i < n - 1) {
			if(i % 2 == 0) { /* split the width */
				cw = (i == 0) ? (int)(w * mon->mfact) : w / 2;
				if(cw <= 2 * c->bw + (int)g || w - cw <= 2 * c->bw + (int)g)
					split = 0;
				else if(s || i % 4 == 0) { /* take the left part */
					x += cw;
				} else {                   /* spiral: take the right part */
					cx = x + w - cw;
				}
				if(split)
					w -= cw;
			} else {         /* split the height */
				ch = h / 2;
				if(ch <= 2 * c->bw + (int)g || h - ch <= 2 * c->bw + (int)g)
					split = 0;
				else if(s || i % 4 == 1) { /* take the top part */
					y += ch;
				} else {                   /* spiral: take the bottom part */
					cy = y + h - ch;
				}
				if(split)
					h -= ch;
			}
			if(!split) { /* too small to split further: share the rest */
				cx = x; cy = y; cw = w; ch = h;
			}
		}
		resize(c, cx, cy, cw - 2 * c->bw - g, ch - 2 * c->bw - g, False);
	}
}

void
dwindle(Monitor *mon) {
	fibonacci(mon, 1);
}

void
spiral(Monitor *mon) {
	fibonacci(mon, 0);
}
