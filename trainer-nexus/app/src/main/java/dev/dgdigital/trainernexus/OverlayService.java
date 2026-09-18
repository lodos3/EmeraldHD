package dev.dgdigital.trainernexus;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.content.pm.ServiceInfo;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.os.Build;
import android.os.IBinder;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.TextView;

public class OverlayService extends Service {
    private static final String CHANNEL = "companion_overlay";
    private WindowManager windowManager;
    private LinearLayout overlay;
    private LinearLayout panel;
    private WindowManager.LayoutParams params;
    private float downX, downY;
    private int startX, startY;
    private boolean moved;

    @Override
    public void onCreate() {
        super.onCreate();
        createChannel();
        showOverlay();
        startForegroundCompat();
    }

    private void startForegroundCompat() {
        Intent open = new Intent(this, MainActivity.class);
        PendingIntent pending = PendingIntent.getActivity(this, 0, open, PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT);
        Notification.Builder b = Build.VERSION.SDK_INT >= 26 ? new Notification.Builder(this, CHANNEL) : new Notification.Builder(this);
        b.setContentTitle("Trainer Nexus companion")
                .setContentText("Quick companion bubble is active")
                .setSmallIcon(android.R.drawable.ic_menu_compass)
                .setContentIntent(pending)
                .setOngoing(true);
        if (Build.VERSION.SDK_INT >= 34) {
            startForeground(41, b.build(), ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE);
        } else {
            startForeground(41, b.build());
        }
    }

    private void createChannel() {
        if (Build.VERSION.SDK_INT >= 26) {
            NotificationChannel c = new NotificationChannel(CHANNEL, "Companion overlay", NotificationManager.IMPORTANCE_LOW);
            c.setDescription("Keeps the user-enabled Trainer Nexus companion bubble available.");
            ((NotificationManager) getSystemService(NOTIFICATION_SERVICE)).createNotificationChannel(c);
        }
    }

    private void showOverlay() {
        windowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        overlay = new LinearLayout(this);
        overlay.setOrientation(LinearLayout.VERTICAL);
        overlay.setGravity(Gravity.END);

        TextView bubble = Ui.text(this, "◎", 26, Color.WHITE, true);
        bubble.setGravity(Gravity.CENTER);
        bubble.setBackground(Ui.bg(Palette.CYAN, 50, this));
        overlay.addView(bubble, new LinearLayout.LayoutParams(Ui.dp(this, 56), Ui.dp(this, 56)));

        panel = new LinearLayout(this);
        panel.setOrientation(LinearLayout.VERTICAL);
        panel.setPadding(Ui.dp(this, 8), Ui.dp(this, 8), Ui.dp(this, 8), Ui.dp(this, 8));
        panel.setBackground(Ui.bg(Color.argb(245, 20, 39, 61), 18, this));
        panel.setVisibility(View.GONE);
        addPanelButton("RAIDS", 1);
        addPanelButton("FRIENDS", 2);
        addPanelButton("COMMUNITY", 3);
        addPanelButton("TOOLS", 4);
        TextView close = Ui.button(this, "CLOSE", Palette.RED, Color.WHITE);
        close.setOnClickListener(v -> stopSelf());
        panel.addView(close, Ui.margin(this, 132, 44, 0, 4, 0, 0));
        overlay.addView(panel, Ui.margin(this, -2, -2, 0, 6, 0, 0));

        params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                Build.VERSION.SDK_INT >= 26 ? WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY : WindowManager.LayoutParams.TYPE_PHONE,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
                PixelFormat.TRANSLUCENT);
        params.gravity = Gravity.TOP | Gravity.END;
        params.x = Ui.dp(this, 10);
        params.y = Ui.dp(this, 180);
        windowManager.addView(overlay, params);

        bubble.setOnTouchListener((v, event) -> {
            switch (event.getActionMasked()) {
                case MotionEvent.ACTION_DOWN -> {
                    moved = false;
                    downX = event.getRawX();
                    downY = event.getRawY();
                    startX = params.x;
                    startY = params.y;
                    return true;
                }
                case MotionEvent.ACTION_MOVE -> {
                    float dx = event.getRawX() - downX;
                    float dy = event.getRawY() - downY;
                    if (Math.abs(dx) + Math.abs(dy) > Ui.dp(this, 8)) moved = true;
                    params.x = Math.max(0, startX - (int) dx);
                    params.y = Math.max(0, startY + (int) dy);
                    windowManager.updateViewLayout(overlay, params);
                    return true;
                }
                case MotionEvent.ACTION_UP -> {
                    if (!moved) panel.setVisibility(panel.getVisibility() == View.VISIBLE ? View.GONE : View.VISIBLE);
                    return true;
                }
            }
            return false;
        });
    }

    private void addPanelButton(String label, int tab) {
        TextView b = Ui.button(this, label, Color.argb(30, 255, 255, 255), Color.WHITE);
        b.setOnClickListener(v -> {
            Intent i = new Intent(this, MainActivity.class);
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.putExtra("tab", tab);
            startActivity(i);
        });
        panel.addView(b, Ui.margin(this, 132, 44, 0, 2, 0, 2));
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        if (overlay != null && windowManager != null) windowManager.removeView(overlay);
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) { return null; }
}
