package dev.dgdigital.trainernexus;

import java.util.ArrayList;
import java.util.List;

final class SearchStringBuilder {
    static String build(boolean recent, boolean lowStars, boolean excludeFavourite,
                        boolean excludeShiny, boolean excludeLegendary) {
        List<String> parts = new ArrayList<>();
        if (recent) parts.add("age0");
        if (lowStars) parts.add("0*,1*,2*");
        if (excludeFavourite) parts.add("!favorite");
        if (excludeShiny) parts.add("!shiny");
        if (excludeLegendary) parts.add("!legendary");
        return String.join("&", parts);
    }

    private SearchStringBuilder() {}
}
