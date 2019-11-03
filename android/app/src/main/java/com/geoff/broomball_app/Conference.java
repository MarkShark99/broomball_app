import java.util.HashMap;

public class Conference
{
    private HashMap<String, Division> divisions;

    public Conference()
    {
        divisions = new HashMap<>();
    }

    public void addDivision(String name, Division division)
    {
        divisions.put(name, division);
    }
}
