package whisper;

import com.google.gson.JsonObject;

public class Whisper {

    public JsonObject solve(JsonObject question) {
        int start = question.get("start").getAsInt();

        int end = start;

        return answer(end);
    }

    private static JsonObject answer(int end) {
        JsonObject answer = new JsonObject();
        answer.addProperty("end", end);
        return answer;
    }
}
