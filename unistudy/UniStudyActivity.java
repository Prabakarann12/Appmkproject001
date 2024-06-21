package com.example.unistudy;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import androidx.appcompat.app.AppCompatActivity;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class UniStudyActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_uni_study);
    }

    public void search(View view) {
        Intent srchint = new Intent(UniStudyActivity.this,SearchActivity.class);
        startActivity(srchint);
    }

    public void joinNow(View view) {
        Intent joinint = new Intent(UniStudyActivity.this, FAQActivity.class);
        startActivity(joinint);
    }

    public void usa(View view) {
        String url = "https://www.usnews.com/best-colleges/rankings/national-universities";
        Intent usaint = new Intent(Intent.ACTION_VIEW);
        usaint.setData(Uri.parse(url));
        startActivity(usaint);
    }

    public void uk(View view) {
        String url = "https://www.usnews.com/education/best-global-universities/united-kingdom";
        Intent ukint = new Intent(Intent.ACTION_VIEW);
        ukint.setData(Uri.parse(url));
        startActivity(ukint);
    }

    public void Australia(View view) {
        String url = "https://www.usnews.com/education/best-global-universities/australia";
        Intent australiaint = new Intent(Intent.ACTION_VIEW);
        australiaint.setData(Uri.parse(url));
        startActivity(australiaint);
    }

    public void canada(View view) {
        String url = "https://www.usnews.com/education/best-global-universities/canada";
        Intent canadaint = new Intent(Intent.ACTION_VIEW);
        canadaint.setData(Uri.parse(url));
        startActivity(canadaint);
    }

    public void find1(View view) {
        Intent f1int = new Intent(UniStudyActivity.this, SearchActivity.class);
        startActivity(f1int);
    }

    public void tutorials1(View view) {
        Intent tutint = new Intent(UniStudyActivity.this, TutorialsActivity.class);
        startActivity(tutint);
    }

    public void book1(View view) {
        Intent bookint = new Intent(UniStudyActivity.this, BookActivity.class);
        startActivity(bookint);
    }

    public void account1(View view) {
        Intent actint = new Intent(UniStudyActivity.this, AccountActivity.class);
        startActivity(actint);
    }

    public void explore1(View view) {
        Intent expint = new Intent(UniStudyActivity.this, HomeActivity.class);
        startActivity(expint);
    }
}