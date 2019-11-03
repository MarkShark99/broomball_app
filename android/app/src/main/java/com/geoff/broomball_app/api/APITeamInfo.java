package api;

public class APITeamInfo
{
    private String id;
    private String season_id;
    private String registration_league_id;
    private String season_league_id;
    private String conference_number;
    private String name;
    private String rejected_round_1_name;
    private String rejected_round_2_name;
    private String captain_player_id;
    private String name_approved;
    private String free_players;
    private String balls_ordered;
    private String registration_time;
    private String valid_roster;

    public String getId()
    {
        return id;
    }

    public String getSeason_id()
    {
        return season_id;
    }

    public String getRegistration_league_id()
    {
        return registration_league_id;
    }

    public String getSeason_league_id()
    {
        return season_league_id;
    }

    public String getConference_number()
    {
        return conference_number;
    }

    public String getName()
    {
        return name;
    }

    public String getRejected_round_1_name()
    {
        return rejected_round_1_name;
    }

    public String getRejected_round_2_name()
    {
        return rejected_round_2_name;
    }

    public String getCaptain_player_id()
    {
        return captain_player_id;
    }

    public String getName_approved()
    {
        return name_approved;
    }

    public String getFree_players()
    {
        return free_players;
    }

    public String getBalls_ordered()
    {
        return balls_ordered;
    }

    public String getRegistration_time()
    {
        return registration_time;
    }

    public String getValid_roster()
    {
        return valid_roster;
    }
}
