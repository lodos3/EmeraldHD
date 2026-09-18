package dev.dgdigital.trainernexus;

import android.Manifest;
import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.HorizontalScrollView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity {
    private static final String[] TABS = {"HOME", "RAIDS", "FRIENDS", "COMMUNITY", "TOOLS"};
    private FrameLayout content;
    private LinearLayout nav;
    private AppPrefs prefs;
    private Uri sharedScreenshot;

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);
        prefs = new AppPrefs(this);
        parseShareIntent(getIntent());
        buildShell();
        showTab(Math.max(0, Math.min(4, getIntent().getIntExtra("tab", 0))));
        requestNotificationsIfUseful();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        parseShareIntent(intent);
        if (intent.hasExtra("tab")) showTab(Math.max(0, Math.min(4, intent.getIntExtra("tab", 0))));
        else if (sharedScreenshot != null) showTab(4);
    }

    private void requestNotificationsIfUseful() {
        if (Build.VERSION.SDK_INT >= 33 && checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Manifest.permission.POST_NOTIFICATIONS}, 500);
        }
    }

    private void parseShareIntent(Intent intent) {
        if (Intent.ACTION_SEND.equals(intent.getAction()) && intent.getType() != null && intent.getType().startsWith("image/")) {
            if (Build.VERSION.SDK_INT >= 33) {
                sharedScreenshot = intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri.class);
            } else {
                //noinspection deprecation
                sharedScreenshot = intent.getParcelableExtra(Intent.EXTRA_STREAM);
            }
        }
    }

    private void buildShell() {
        LinearLayout shell = new LinearLayout(this);
        shell.setOrientation(LinearLayout.VERTICAL);
        shell.setBackgroundColor(Palette.BG);

        shell.addView(topBar(), new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, Ui.dp(this, 68)));
        content = new FrameLayout(this);
        shell.addView(content, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 0, 1f));
        nav = bottomNav();
        shell.addView(nav, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, Ui.dp(this, 70)));
        setContentView(shell);
    }

    private View topBar() {
        LinearLayout bar = new LinearLayout(this);
        bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding(Ui.dp(this, 16), Ui.dp(this, 8), Ui.dp(this, 14), Ui.dp(this, 8));
        bar.setBackgroundColor(Palette.NAVY);

        TextView mark = Ui.text(this, "◎", 27, Color.WHITE, true);
        mark.setGravity(Gravity.CENTER);
        mark.setBackground(Ui.bg(Palette.CYAN, 40, this));
        bar.addView(mark, new LinearLayout.LayoutParams(Ui.dp(this, 44), Ui.dp(this, 44)));

        LinearLayout titles = new LinearLayout(this);
        titles.setOrientation(LinearLayout.VERTICAL);
        titles.setPadding(Ui.dp(this, 11), 0, 0, 0);
        titles.addView(Ui.text(this, "TRAINER NEXUS", 16, Color.WHITE, true));
        titles.addView(Ui.text(this, "community companion", 11, Color.rgb(185, 207, 226), false));
        bar.addView(titles, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));

        TextView status = Ui.pill(this, prefs.isAvailable() ? "AVAILABLE" : "OFFLINE", prefs.isAvailable() ? Palette.LIME : Palette.MUTED, Color.WHITE);
        status.setOnClickListener(v -> {
            prefs.setAvailable(!prefs.isAvailable());
            ((TextView) v).setText(prefs.isAvailable() ? "AVAILABLE" : "OFFLINE");
            v.setBackground(Ui.bg(prefs.isAvailable() ? Palette.LIME : Palette.MUTED, 30, this));
        });
        bar.addView(status);
        return bar;
    }

    private LinearLayout bottomNav() {
        LinearLayout row = new LinearLayout(this);
        row.setGravity(Gravity.CENTER);
        row.setPadding(Ui.dp(this, 4), Ui.dp(this, 5), Ui.dp(this, 4), Ui.dp(this, 7));
        row.setBackgroundColor(Color.WHITE);
        for (int i = 0; i < TABS.length; i++) {
            final int index = i;
            TextView t = Ui.text(this, TABS[i], 10, Palette.MUTED, true);
            t.setGravity(Gravity.CENTER);
            t.setTag(i);
            t.setContentDescription("Open " + TABS[i].toLowerCase());
            t.setOnClickListener(v -> showTab(index));
            row.addView(t, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.MATCH_PARENT, 1f));
        }
        return row;
    }

    private void showTab(int index) {
        for (int i = 0; i < nav.getChildCount(); i++) {
            TextView t = (TextView) nav.getChildAt(i);
            boolean selected = i == index;
            t.setTextColor(selected ? Palette.CYAN_DARK : Palette.MUTED);
            t.setBackground(selected ? Ui.bg(Color.rgb(231, 247, 251), 16, this) : null);
        }
        content.removeAllViews();
        View page = switch (index) {
            case 1 -> raidsPage();
            case 2 -> friendsPage();
            case 3 -> communityPage();
            case 4 -> toolsPage();
            default -> homePage();
        };
        content.addView(page);
    }

    private ScrollView pageRoot() {
        ScrollView scroll = new ScrollView(this);
        scroll.setFillViewport(true);
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(0, Ui.dp(this, 8), 0, Ui.dp(this, 22));
        scroll.addView(root, new ScrollView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        scroll.setTag(root);
        return scroll;
    }

    private LinearLayout rootOf(ScrollView scroll) { return (LinearLayout) scroll.getTag(); }

    private View homePage() {
        ScrollView scroll = pageRoot();
        LinearLayout root = rootOf(scroll);
        Ui.addTitle(root, this, "LIVE COMPANION", "Play together, with less friction", "Find the right people for raids, trades and events without handing over your game account.");

        LinearLayout hero = Ui.card(this);
        LinearLayout top = new LinearLayout(this);
        top.setGravity(Gravity.CENTER_VERTICAL);
        LinearLayout names = new LinearLayout(this);
        names.setOrientation(LinearLayout.VERTICAL);
        names.addView(Ui.text(this, prefs.trainerName(), 20, Palette.INK, true));
        names.addView(Ui.text(this, prefs.homeArea(), 12, Palette.MUTED, false));
        top.addView(names, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
        top.addView(Ui.pill(this, prefs.isAvailable() ? "RAID READY" : "OFFLINE", prefs.isAvailable() ? Palette.LIME : Palette.MUTED, Color.WHITE));
        hero.addView(top);
        hero.addView(Ui.gap(this, 14));
        hero.addView(Ui.text(this, "3 high-quality matches right now", 16, Palette.NAVY, true));
        hero.addView(Ui.text(this, "1 raid squad · 1 reciprocal trade · 1 event crew", 12, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 5, 0, 0));
        TextView openMatches = Ui.button(this, "OPEN SMART MATCHES", Palette.CYAN, Color.WHITE);
        openMatches.setOnClickListener(v -> showTab(3));
        hero.addView(openMatches, Ui.margin(this, -1, -2, 0, 16, 0, 0));
        root.addView(hero);

        sectionLabel(root, "YOUR HUNT BOARD");
        for (Models.Hunt h : Models.hunts()) {
            LinearLayout row = Ui.card(this);
            LinearLayout line = new LinearLayout(this);
            line.setGravity(Gravity.CENTER_VERTICAL);
            LinearLayout copy = new LinearLayout(this);
            copy.setOrientation(LinearLayout.VERTICAL);
            copy.addView(Ui.text(this, h.pokemon(), 15, Palette.INK, true));
            copy.addView(Ui.text(this, h.goal(), 12, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 4, 0, 0));
            line.addView(copy, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
            line.addView(Ui.pill(this, h.priority(), h.priority().equals("HIGH") ? Palette.ORANGE : Palette.PURPLE, Color.WHITE));
            row.addView(line);
            root.addView(row);
        }

        sectionLabel(root, "ACCESSIBILITY");
        LinearLayout accessibility = Ui.card(this);
        LinearLayout switchRow = new LinearLayout(this);
        switchRow.setGravity(Gravity.CENTER_VERTICAL);
        LinearLayout copy = new LinearLayout(this);
        copy.setOrientation(LinearLayout.VERTICAL);
        copy.addView(Ui.text(this, "Accessibility-first matching", 15, Palette.INK, true));
        copy.addView(Ui.text(this, "Prioritise step-free venues, seating and your selected play requirements.", 12, Palette.MUTED, false));
        switchRow.addView(copy, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
        Switch sw = new Switch(this);
        sw.setChecked(prefs.accessibilityMode());
        sw.setOnCheckedChangeListener((buttonView, isChecked) -> prefs.setAccessibilityMode(isChecked));
        switchRow.addView(sw);
        accessibility.addView(switchRow);
        root.addView(accessibility);
        return scroll;
    }

    private View raidsPage() {
        ScrollView scroll = pageRoot();
        LinearLayout root = rootOf(scroll);
        Ui.addTitle(root, this, "RAID NETWORK", "Groups that are actually ready", "Match by availability, reliability, accessibility and group strength — not just headcount.");

        LinearLayout actions = horizontalButtons("CREATE RAID", "RAID SOS", "MY SQUADS");
        root.addView(actions, Ui.margin(this, -1, -2, 12, 0, 12, 10));

        for (Models.Raid raid : Models.raids()) {
            LinearLayout card = Ui.card(this);
            LinearLayout top = new LinearLayout(this);
            top.setGravity(Gravity.CENTER_VERTICAL);
            LinearLayout copy = new LinearLayout(this);
            copy.setOrientation(LinearLayout.VERTICAL);
            copy.addView(Ui.text(this, raid.boss(), 18, Palette.INK, true));
            copy.addView(Ui.text(this, raid.tier() + " · " + raid.area(), 12, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 4, 0, 0));
            top.addView(copy, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
            top.addView(Ui.pill(this, raid.time(), Color.rgb(232, 245, 250), Palette.CYAN_DARK));
            card.addView(top);
            card.addView(Ui.gap(this, 13));
            card.addView(Ui.text(this, raid.ready() + " READY  ·  " + (raid.needed() == 0 ? "GROUP READY" : raid.needed() + " NEEDED"), 13, Palette.NAVY, true));
            card.addView(Ui.text(this, raid.note(), 12, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 5, 0, 0));
            TextView join = Ui.button(this, raid.needed() == 0 ? "VIEW SQUAD" : "JOIN GROUP", raid.needed() == 0 ? Palette.NAVY : Palette.CYAN, Color.WHITE);
            join.setOnClickListener(v -> toast("Foundation: raid room flow is wired for the community backend next."));
            card.addView(join, Ui.margin(this, -1, -2, 0, 14, 0, 0));
            root.addView(card);
        }

        sectionLabel(root, "RELIABILITY MODEL");
        LinearLayout info = Ui.card(this);
        info.addView(Ui.text(this, "Reputation without a toxic star score", 16, Palette.INK, true));
        info.addView(Ui.text(this, "Show completed raids, join reliability and host history as factual signals. The foundation keeps these as separate metrics so a future backend does not collapse players into one opaque rating.", 13, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 8, 0, 0));
        root.addView(info);
        return scroll;
    }

    private View friendsPage() {
        ScrollView scroll = pageRoot();
        LinearLayout root = rootOf(scroll);
        Ui.addTitle(root, this, "FRIEND NETWORK", "Remember why you added them", "Organise raids, gifts, trades, Vivillon and PvP contacts without accessing your Pokémon GO account.");

        EditText search = new EditText(this);
        search.setHint("Search people, tags or purpose");
        search.setSingleLine(true);
        search.setTextColor(Palette.INK);
        search.setHintTextColor(Palette.MUTED);
        search.setBackground(Ui.outlined(Color.WHITE, Palette.BORDER, 18, this));
        search.setPadding(Ui.dp(this, 15), 0, Ui.dp(this, 15), 0);
        root.addView(search, Ui.margin(this, -1, 52, 16, 2, 16, 10));

        LinearLayout tagRow = horizontalButtons("RAIDS", "GIFTS", "TRADES", "VIVILLON");
        root.addView(tagRow, Ui.margin(this, -1, -2, 12, 0, 12, 8));

        for (Models.Trainer trainer : Models.trainers()) {
            LinearLayout card = Ui.card(this);
            LinearLayout top = new LinearLayout(this);
            top.setGravity(Gravity.CENTER_VERTICAL);
            TextView avatar = Ui.text(this, trainer.name().substring(0, 1), 18, Color.WHITE, true);
            avatar.setGravity(Gravity.CENTER);
            avatar.setBackground(Ui.bg(Palette.PURPLE, 50, this));
            top.addView(avatar, new LinearLayout.LayoutParams(Ui.dp(this, 44), Ui.dp(this, 44)));
            LinearLayout copy = new LinearLayout(this);
            copy.setOrientation(LinearLayout.VERTICAL);
            copy.setPadding(Ui.dp(this, 12), 0, 0, 0);
            copy.addView(Ui.text(this, trainer.name(), 16, Palette.INK, true));
            copy.addView(Ui.text(this, trainer.tags(), 11, Palette.CYAN_DARK, true), Ui.margin(this, -1, -2, 0, 3, 0, 0));
            top.addView(copy, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
            top.addView(Ui.pill(this, trainer.reliability() + "% JOIN", Color.rgb(237, 247, 238), Palette.LIME));
            card.addView(top);
            card.addView(Ui.text(this, trainer.status() + " · " + trainer.raids() + " raids completed", 12, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 12, 0, 0));
            root.addView(card);
        }

        sectionLabel(root, "LUCKY TRADE BOARD");
        LinearLayout trade = Ui.card(this);
        trade.addView(Ui.text(this, "2 reciprocal wishlist matches", 17, Palette.INK, true));
        trade.addView(Ui.text(this, "Matches are discovered from community wishlists. Trading remains entirely player-controlled in Pokémon GO.", 12, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 6, 0, 0));
        TextView review = Ui.button(this, "REVIEW MATCHES", Palette.ORANGE, Color.WHITE);
        review.setOnClickListener(v -> toast("Foundation: trade matching UI ready for persistent community data."));
        trade.addView(review, Ui.margin(this, -1, -2, 0, 14, 0, 0));
        root.addView(trade);
        return scroll;
    }

    private View communityPage() {
        ScrollView scroll = pageRoot();
        LinearLayout root = rootOf(scroll);
        Ui.addTitle(root, this, "COMMUNITY", "Intent beats notification spam", "Tell the network what you want to do now. It surfaces compatible players instead of broadcasting everything to everyone.");

        LinearLayout beacon = Ui.card(this);
        beacon.addView(Ui.text(this, "Availability beacon", 17, Palette.INK, true));
        beacon.addView(Ui.text(this, prefs.isAvailable() ? "You are currently discoverable for matching." : "Your beacon is currently offline.", 12, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 6, 0, 0));
        LinearLayout toggles = horizontalButtons("REMOTE RAID", "LOCAL", "TRADES", "PVP");
        beacon.addView(toggles, Ui.margin(this, -1, -2, -4, 12, -4, 0));
        root.addView(beacon);

        sectionLabel(root, "LIVE BOARD");
        for (Models.CommunityPost post : Models.posts()) {
            LinearLayout card = Ui.card(this);
            card.addView(Ui.text(this, post.meta(), 11, Palette.CYAN_DARK, true));
            card.addView(Ui.text(this, post.title(), 18, Palette.INK, true), Ui.margin(this, -1, -2, 0, 7, 0, 0));
            card.addView(Ui.text(this, post.body(), 13, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 6, 0, 0));
            TextView action = Ui.button(this, post.action(), Palette.NAVY, Color.WHITE);
            action.setOnClickListener(v -> toast("Community action captured. Backend wiring comes next."));
            card.addView(action, Ui.margin(this, -1, -2, 0, 14, 0, 0));
            root.addView(card);
        }

        sectionLabel(root, "ACCESSIBLE VENUES");
        LinearLayout accessible = Ui.card(this);
        accessible.addView(Ui.text(this, "Community accessibility layer", 16, Palette.INK, true));
        accessible.addView(Ui.text(this, "Venue records are designed for step-free access, seating, parking, shelter and toilet availability. Exact location sharing is opt-in rather than assumed.", 13, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 7, 0, 0));
        root.addView(accessible);
        return scroll;
    }

    private View toolsPage() {
        ScrollView scroll = pageRoot();
        LinearLayout root = rootOf(scroll);
        Ui.addTitle(root, this, "TOOLS", "Useful without touching the game client", "Generate searches, analyse user-shared screenshots and keep quick companion information available while you play.");

        LinearLayout screenshot = Ui.card(this);
        screenshot.addView(Ui.text(this, "Screenshot intake", 17, Palette.INK, true));
        String shotStatus = sharedScreenshot == null ? "Share an image to Trainer Nexus from Android's Share menu." : "Screenshot received and ready for the analysis pipeline.";
        screenshot.addView(Ui.text(this, shotStatus, 12, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 6, 0, 0));
        if (sharedScreenshot != null) {
            TextView uri = Ui.text(this, sharedScreenshot.toString(), 10, Palette.CYAN_DARK, false);
            uri.setMaxLines(2);
            screenshot.addView(uri, Ui.margin(this, -1, -2, 0, 8, 0, 0));
        }
        TextView analyse = Ui.button(this, sharedScreenshot == null ? "HOW TO SHARE" : "ANALYSE SCREENSHOT", Palette.CYAN, Color.WHITE);
        analyse.setOnClickListener(v -> toast(sharedScreenshot == null ? "Open a Pokémon screenshot, tap Share, then choose Trainer Nexus." : "Foundation intake works. OCR/stat interpretation is the next module."));
        screenshot.addView(analyse, Ui.margin(this, -1, -2, 0, 14, 0, 0));
        root.addView(screenshot);

        root.addView(searchBuilderCard());

        LinearLayout overlay = Ui.card(this);
        overlay.addView(Ui.text(this, "Companion bubble", 17, Palette.INK, true));
        overlay.addView(Ui.text(this, "A user-enabled floating shortcut for raids, friends, community and timers. It displays our own information only and sends no input to Pokémon GO.", 12, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 6, 0, 0));
        TextView start = Ui.button(this, "ENABLE COMPANION BUBBLE", Palette.PURPLE, Color.WHITE);
        start.setOnClickListener(v -> enableOverlay());
        overlay.addView(start, Ui.margin(this, -1, -2, 0, 14, 0, 0));
        root.addView(overlay);

        LinearLayout profile = Ui.card(this);
        profile.addView(Ui.text(this, "Local profile", 17, Palette.INK, true));
        EditText name = field("Trainer display name", prefs.trainerName());
        EditText area = field("Community / general area", prefs.homeArea());
        profile.addView(name, Ui.margin(this, -1, 50, 0, 12, 0, 0));
        profile.addView(area, Ui.margin(this, -1, 50, 0, 8, 0, 0));
        TextView save = Ui.button(this, "SAVE PROFILE", Palette.NAVY, Color.WHITE);
        save.setOnClickListener(v -> {
            prefs.setTrainerName(name.getText().toString());
            prefs.setHomeArea(area.getText().toString());
            toast("Profile saved locally.");
        });
        profile.addView(save, Ui.margin(this, -1, -2, 0, 12, 0, 0));
        root.addView(profile);
        return scroll;
    }

    private LinearLayout searchBuilderCard() {
        LinearLayout card = Ui.card(this);
        card.addView(Ui.text(this, "Pokémon search-string builder", 17, Palette.INK, true));
        card.addView(Ui.text(this, "Create a search, copy it, then paste it into Pokémon GO yourself.", 12, Palette.MUTED, false), Ui.margin(this, -1, -2, 0, 5, 0, 7));
        CheckBox recent = box("Caught today", true);
        CheckBox lowStars = box("0–2 star appraisal", true);
        CheckBox fav = box("Exclude favourites", true);
        CheckBox shiny = box("Exclude shiny", true);
        CheckBox legendary = box("Exclude legendary", true);
        card.addView(recent); card.addView(lowStars); card.addView(fav); card.addView(shiny); card.addView(legendary);
        TextView output = Ui.text(this, "", 13, Palette.NAVY, true);
        output.setPadding(Ui.dp(this, 12), Ui.dp(this, 11), Ui.dp(this, 12), Ui.dp(this, 11));
        output.setBackground(Ui.bg(Color.rgb(238, 244, 249), 14, this));
        CompoundButton.OnCheckedChangeListener listener = (buttonView, isChecked) -> output.setText(SearchStringBuilder.build(recent.isChecked(), lowStars.isChecked(), fav.isChecked(), shiny.isChecked(), legendary.isChecked()));
        recent.setOnCheckedChangeListener(listener); lowStars.setOnCheckedChangeListener(listener); fav.setOnCheckedChangeListener(listener); shiny.setOnCheckedChangeListener(listener); legendary.setOnCheckedChangeListener(listener);
        listener.onCheckedChanged(recent, true);
        card.addView(output, Ui.margin(this, -1, -2, 0, 8, 0, 0));
        TextView copy = Ui.button(this, "COPY SEARCH", Palette.ORANGE, Color.WHITE);
        copy.setOnClickListener(v -> {
            ClipboardManager cm = (ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
            cm.setPrimaryClip(ClipData.newPlainText("Pokemon search", output.getText()));
            toast("Search copied.");
        });
        card.addView(copy, Ui.margin(this, -1, -2, 0, 12, 0, 0));
        return card;
    }

    private CheckBox box(String text, boolean checked) {
        CheckBox b = new CheckBox(this);
        b.setText(text);
        b.setTextSize(13);
        b.setTextColor(Palette.INK);
        b.setChecked(checked);
        b.setMinHeight(Ui.dp(this, 42));
        return b;
    }

    private EditText field(String hint, String value) {
        EditText e = new EditText(this);
        e.setHint(hint);
        e.setText(value);
        e.setSingleLine(true);
        e.setTextColor(Palette.INK);
        e.setHintTextColor(Palette.MUTED);
        e.setBackground(Ui.outlined(Color.WHITE, Palette.BORDER, 15, this));
        e.setPadding(Ui.dp(this, 12), 0, Ui.dp(this, 12), 0);
        return e;
    }

    private LinearLayout horizontalButtons(String... labels) {
        HorizontalScrollView hsv = new HorizontalScrollView(this);
        hsv.setHorizontalScrollBarEnabled(false);
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        for (String label : labels) {
            TextView p = Ui.pill(this, label, Color.WHITE, Palette.NAVY);
            p.setBackground(Ui.outlined(Color.WHITE, Palette.BORDER, 30, this));
            p.setMinHeight(Ui.dp(this, 40));
            p.setGravity(Gravity.CENTER);
            p.setOnClickListener(v -> toast(label + " selected"));
            row.addView(p, Ui.margin(this, -2, 40, 4, 0, 4, 0));
        }
        hsv.addView(row);
        LinearLayout wrap = new LinearLayout(this);
        wrap.addView(hsv, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        return wrap;
    }

    private void sectionLabel(LinearLayout root, String label) {
        TextView t = Ui.text(this, label, 11, Palette.MUTED, true);
        t.setLetterSpacing(.08f);
        root.addView(t, Ui.margin(this, -1, -2, 20, 18, 20, 3));
    }

    private void enableOverlay() {
        if (!Settings.canDrawOverlays(this)) {
            Intent i = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + getPackageName()));
            startActivity(i);
            toast("Allow display over other apps, then tap Enable again.");
            return;
        }
        Intent service = new Intent(this, OverlayService.class);
        if (Build.VERSION.SDK_INT >= 26) startForegroundService(service); else startService(service);
        toast("Companion bubble enabled.");
    }

    private void toast(String s) { Toast.makeText(this, s, Toast.LENGTH_SHORT).show(); }
}
