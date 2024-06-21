package com.example.unistudy;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.material.textfield.TextInputEditText;

import java.util.HashMap;
import java.util.Map;


public class FAQActivity extends AppCompatActivity {

    TextInputEditText Study, Career,Cultural,Personal;

    Button Submit;
   String url="https://syfer001testing.000webhostapp.com/cloneapi/faquni.php";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_faqactivity);
        Study = findViewById(R.id.goalEditText);
        Career = findViewById(R.id.aspirationEditText);
        Cultural = findViewById(R.id.culturalsEditText);
        Personal = findViewById(R.id.pgEditText);
        Submit = findViewById(R.id.submit);
    }

    public void submit(View view) {
        String study = Study.getText().toString().trim();
        String career = Career.getText().toString().trim();
        String cultural = Cultural.getText().toString().trim();
        String personal = Personal.getText().toString().trim();
        userSubmit(study, career,cultural,personal);

        if (study.isEmpty() || career.isEmpty() || cultural.isEmpty() || personal.isEmpty()) {
            Toast.makeText(this, "Please fill all answers", Toast.LENGTH_SHORT).show();
        } else {
            userSubmit(study, career, cultural, personal);
        }
    }

    private void userSubmit(String study, String career, String cultural, String personal) {
        StringRequest request = new StringRequest(Request.Method.POST, url, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Study.setText("");
                Career.setText("");
                Cultural.setText("");
                Personal.setText("");
                Toast.makeText(getApplicationContext(), response, Toast.LENGTH_LONG).show();
                Toast.makeText(FAQActivity.this, response, Toast.LENGTH_SHORT).show();

            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(FAQActivity.this, error.getMessage(), Toast.LENGTH_SHORT).show();
            }
        }){
            @Nullable
            @Override
            protected Map<String, String> getParams() throws AuthFailureError {
                Map<String, String> map = new HashMap<>();
                map.put("FAQstudy", study);
                map.put("FAQcareer", career);
                map.put("FAQcultural", cultural);
                map.put("FAQpersonal", personal);
                return map;
            }

        };
        RequestQueue requestQueue = Volley.newRequestQueue(this);
        requestQueue.add(request);
    }


}