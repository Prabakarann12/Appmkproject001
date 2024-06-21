package com.example.unistudy;



import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {
    ImageView start,create;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        start = findViewById(R.id.Start);
        create = findViewById(R.id.createBtn);
    }
    public void login(View view) {
        Intent logint  = new Intent(MainActivity.this, LoginActivity.class);
        startActivity(logint);
    }
    public void signUp(View view) {
        Intent signint = new Intent(MainActivity.this, RegisterActivity.class);
        startActivity(signint);
    }
}