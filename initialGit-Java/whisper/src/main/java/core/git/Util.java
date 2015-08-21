package core.git;

import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.storage.file.FileRepositoryBuilder;

public class Util {
    public static String branchName(){
        try {
            FileRepositoryBuilder builder = new FileRepositoryBuilder();
            Repository repository = builder.findGitDir().build();
            return repository.getBranch();
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
            return null;
        }
    }
}
