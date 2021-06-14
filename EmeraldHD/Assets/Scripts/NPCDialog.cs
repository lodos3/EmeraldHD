using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System.Text.RegularExpressions;
using TMPro;

public class NPCDialog : MonoBehaviour
{
    public static Regex R = new Regex(@"<(.*?/\@.*?)>");
    public static Regex C = new Regex(@"{(.*?/.*?)}");
    [HideInInspector]
    public List<string> Lines;    
    public TMP_Text Name, Text, Act;

    public void NewText(string name, List<string> lines)
    {
        Lines = lines;
        Text.text = string.Empty;
        Act.text = string.Empty;
        Name.text = name;

        for (int i = 0; i < Lines.Count; i++)
        {
            List<Match> matchList = R.Matches(lines[i]).Cast<Match>().ToList();
            matchList.AddRange(C.Matches(lines[i]).Cast<Match>());

            foreach (Match match in matchList)
            {
                Capture capture = match.Groups[1].Captures[0];
                string[] values = capture.Value.Split('/');
                lines[i] = lines[i].Remove(capture.Index - 1);
                Act.text += lines[i].Insert(capture.Index - 1, "<sprite=19>" + " " + "<link=" + values[1] + ">" + values[0] + "</link>")+ "\n";
            }
            Text.text += lines[i] + "\n";
        }
    }
}
