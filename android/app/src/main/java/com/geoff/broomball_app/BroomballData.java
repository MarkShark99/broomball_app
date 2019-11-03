import api.APITeam;

import java.util.HashMap;

/**
 * A class to represent all the data loaded from the broomball website.
 */
public class BroomballData
{
    private HashMap<String, Year> years;
    private HashMap<String, APITeam> teams;
    private HashMap<String, Player> players;

    public BroomballData()
    {
        years = new HashMap<>();
        teams = new HashMap<>();
        players = new HashMap<>();
    }

    public void addYear(String id, Year year)
    {
        this.years.put(id, year);
    }

    public void addTeam(String id, Team team)
    {
        this.teams.put(id, team);
    }

    public void addPlayer(String id, Player player)
    {
        this.players.put(id, player);
    }

}
