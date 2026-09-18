package dev.dgdigital.trainernexus;

import android.content.Context;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.Space;
import android.widget.TextView;

final class Ui {
    static int dp(Context c, int v) {
        return Math.round(v * c.getResources().getDisplayMetrics().density);
    }

    static TextView text(Context c, String value, float sp, int color, boolean bold) {
        TextView t = new TextView(c);
        t.setText(value);
        t.setTextSize(sp);
        t.setTextColor(color);
        if (bold) t.setTypeface(Typeface.create("sans-serif", Typeface.BOLD));
        t.setIncludeFontPadding(false);
        return t;
    }

    static GradientDrawable bg(int color, float radiusDp, Context c) {
        GradientDrawable g = new GradientDrawable();
        g.setColor(color);
        g.setCornerRadius(dp(c, (int) radiusDp));
        return g;
    }

    static GradientDrawable outlined(int color, int stroke, float radiusDp, Context c) {
        GradientDrawable g = bg(color, radiusDp, c);
        g.setStroke(dp(c, 1), stroke);
        return g;
    }

    static LinearLayout card(Context c) {
        LinearLayout box = new LinearLayout(c);
        box.setOrientation(LinearLayout.VERTICAL);
        box.setPadding(dp(c, 16), dp(c, 15), dp(c, 16), dp(c, 15));
        box.setBackground(outlined(Palette.CARD, Palette.BORDER, 20, c));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.setMargins(dp(c, 16), dp(c, 6), dp(c, 16), dp(c, 6));
        box.setLayoutParams(lp);
        return box;
    }

    static TextView pill(Context c, String label, int bg, int fg) {
        TextView p = text(c, label, 11, fg, true);
        p.setGravity(Gravity.CENTER);
        p.setPadding(dp(c, 10), dp(c, 6), dp(c, 10), dp(c, 6));
        p.setBackground(Ui.bg(bg, 30, c));
        return p;
    }

    static TextView button(Context c, String label, int bg, int fg) {
        TextView b = text(c, label, 13, fg, true);
        b.setGravity(Gravity.CENTER);
        b.setMinHeight(dp(c, 48));
        b.setPadding(dp(c, 14), dp(c, 12), dp(c, 14), dp(c, 12));
        b.setBackground(Ui.bg(bg, 16, c));
        b.setClickable(true);
        b.setFocusable(true);
        return b;
    }

    static void addTitle(LinearLayout root, Context c, String eyebrow, String title, String subtitle) {
        TextView e = text(c, eyebrow, 11, Palette.CYAN_DARK, true);
        e.setLetterSpacing(.08f);
        root.addView(e, margin(c, -1, -2, 20, 18, 20, 0));
        root.addView(text(c, title, 28, Palette.INK, true), margin(c, -1, -2, 20, 8, 20, 0));
        TextView s = text(c, subtitle, 14, Palette.MUTED, false);
        s.setLineSpacing(0, 1.15f);
        root.addView(s, margin(c, -1, -2, 20, 8, 20, 12));
    }

    static LinearLayout.LayoutParams margin(Context c, int w, int h, int l, int t, int r, int b) {
        int ww = w == -1 ? ViewGroup.LayoutParams.MATCH_PARENT : (w == -2 ? ViewGroup.LayoutParams.WRAP_CONTENT : dp(c, w));
        int hh = h == -1 ? ViewGroup.LayoutParams.MATCH_PARENT : (h == -2 ? ViewGroup.LayoutParams.WRAP_CONTENT : dp(c, h));
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(ww, hh);
        lp.setMargins(dp(c, l), dp(c, t), dp(c, r), dp(c, b));
        return lp;
    }

    static View gap(Context c, int h) {
        Space s = new Space(c);
        s.setLayoutParams(new LinearLayout.LayoutParams(1, dp(c, h)));
        return s;
    }

    private Ui() {}
}
