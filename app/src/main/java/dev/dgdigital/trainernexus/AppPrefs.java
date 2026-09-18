package dev.dgdigital.trainernexus;

import android.content.Context;
import android.content.SharedPreferences;

final class AppPrefs {
    private static final String FILE = "trainer_nexus_prefs";
    private final SharedPreferences prefs;

    AppPrefs(Context context) {
        prefs = context.getSharedPreferences(FILE, Context.MODE_PRIVATE);
    }

    boolean isAvailable() { return prefs.getBoolean("available", true); }
    void setAvailable(boolean value) { prefs.edit().putBoolean("available", value).apply(); }

    boolean accessibilityMode() { return prefs.getBoolean("accessibility_mode", false); }
    void setAccessibilityMode(boolean value) { prefs.edit().putBoolean("accessibility_mode", value).apply(); }

    String trainerName() { return prefs.getString("trainer_name", "Trainer"); }
    void setTrainerName(String value) { prefs.edit().putString("trainer_name", value.trim()).apply(); }

    String homeArea() { return prefs.getString("home_area", "Your local community"); }
    void setHomeArea(String value) { prefs.edit().putString("home_area", value.trim()).apply(); }
}
