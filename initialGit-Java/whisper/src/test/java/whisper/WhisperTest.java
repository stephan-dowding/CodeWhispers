package whisper;

import com.google.gson.JsonObject;
import org.junit.Test;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;
import static org.hamcrest.core.IsEqual.equalTo;

public class WhisperTest {

    @Test
    public void shouldReturnSameEndAsStart(){
        Whisper whisper = new Whisper();

        JsonObject question = new JsonObject();
        question.addProperty("start", 123);

        JsonObject answer = whisper.solve(question);

        assertThat(answer.get("end").getAsInt(), is(equalTo(123)));
    }

}
