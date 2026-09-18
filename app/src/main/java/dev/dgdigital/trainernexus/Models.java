package dev.dgdigital.trainernexus;

import java.util.List;

final class Models {
    static final class Raid {
        private final String boss, tier, time, area, note;
        private final int ready, needed;
        Raid(String boss, String tier, String time, String area, int ready, int needed, String note) {
            this.boss=boss; this.tier=tier; this.time=time; this.area=area; this.ready=ready; this.needed=needed; this.note=note;
        }
        String boss(){return boss;} String tier(){return tier;} String time(){return time;} String area(){return area;}
        int ready(){return ready;} int needed(){return needed;} String note(){return note;}
    }

    static final class Trainer {
        private final String name, tags, status;
        private final int reliability, raids;
        Trainer(String name, String tags, String status, int reliability, int raids) {
            this.name=name; this.tags=tags; this.status=status; this.reliability=reliability; this.raids=raids;
        }
        String name(){return name;} String tags(){return tags;} String status(){return status;}
        int reliability(){return reliability;} int raids(){return raids;}
    }

    static final class CommunityPost {
        private final String title, meta, body, action;
        CommunityPost(String title, String meta, String body, String action) {
            this.title=title; this.meta=meta; this.body=body; this.action=action;
        }
        String title(){return title;} String meta(){return meta;} String body(){return body;} String action(){return action;}
    }

    static final class Hunt {
        private final String pokemon, goal, priority;
        Hunt(String pokemon, String goal, String priority) { this.pokemon=pokemon; this.goal=goal; this.priority=priority; }
        String pokemon(){return pokemon;} String goal(){return goal;} String priority(){return priority;}
    }

    static List<Raid> raids() {
        return List.of(
                new Raid("Legendary raid", "5★", "Starts in 11 min", "Central group", 4, 2, "Comfortable if two more join"),
                new Raid("Mega raid", "Mega", "Ends in 24 min", "Accessible venue", 3, 3, "Step-free · seating nearby"),
                new Raid("Shadow raid", "Shadow", "Starts in 38 min", "Local meetup", 6, 0, "Squad ready")
        );
    }

    static List<Trainer> trainers() {
        return List.of(
                new Trainer("Nova", "RAIDS · GIFTS", "Available 45 min", 98, 126),
                new Trainer("Moss", "TRADES · LOCAL", "Looking for trades", 95, 73),
                new Trainer("Orbit", "PVP · RAIDS", "Remote-ready", 97, 204),
                new Trainer("Ember", "VIVILLON · GIFTS", "Gift session", 93, 58)
        );
    }

    static List<CommunityPost> posts() {
        return List.of(
                new CommunityPost("Community Day crew", "TODAY · CASUAL + ACCESSIBLE", "A relaxed group with regular seated stops. Five trainers interested.", "JOIN CREW"),
                new CommunityPost("Raid SOS", "12 MIN LEFT · 3 MORE NEEDED", "A local host needs extra remote players for the current lobby.", "VIEW RAID"),
                new CommunityPost("Trade match found", "RECIPROCAL WISHLIST", "Two community wishlists overlap. Review the match before contacting the trainer.", "REVIEW MATCH")
        );
    }

    static List<Hunt> hunts() {
        return List.of(
                new Hunt("Shiny target", "Community alerts + trade board", "HIGH"),
                new Hunt("Lucky Dex", "7 reciprocal trade matches", "MED"),
                new Hunt("Mega energy", "Prioritise matching raid groups", "HIGH")
        );
    }

    private Models() {}
}
