package core.runner;

import com.google.gson.JsonObject;
import core.web.ChallengeServer;
import whisper.Whisper;

import java.util.Map;


public class Runner {
    public static void doChallenge(){
        try {
            JsonObject question = ChallengeServer.getQuestion();
            JsonObject answer = new Whisper().solve(question);
            ChallengeServer.postAnswer(answer);
        } catch (Exception e) {
            onError(e);
        }
    }

    public static void onError(Exception e){
        System.out.println(e.getMessage());
        e.printStackTrace();
        System.exit(2);
    }
}
