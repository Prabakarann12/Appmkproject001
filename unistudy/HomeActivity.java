package com.example.unistudy;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.ImageRequest;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

public class HomeActivity extends AppCompatActivity {

    ImageView imgDataView;
    TextView nameTextView, emailTextView, dobTextView, addressTextView, filePathTextView ;
    Button showBTN;
    JsonObjectRequest jsonObjectRequest;
    RequestQueue requestQueue;
    ImageRequest imageRequest;
    String showUrl , showUrlIMG,imageSW;

    String stuID = "23";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        imgDataView = findViewById(R.id.imgView);
        nameTextView = findViewById(R.id.nameView);
        emailTextView = findViewById(R.id.emailView);
        dobTextView = findViewById(R.id.dobView);
        addressTextView = findViewById(R.id.addressView);
        filePathTextView = findViewById(R.id.FilePath_View);

        showUrl = "https://syfer001testing.000webhostapp.com/cloneapi/showdataAS.php?id=" + stuID;
        ShowUserDataHP();



    }

    private void ShowUserDataHP() {
        requestQueue = Volley.newRequestQueue(HomeActivity.this);

        jsonObjectRequest = new JsonObjectRequest
                (Request.Method.GET, showUrl, null, new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        parseJsonData(response);
                        // Update the image URL after parsing the response
                        showUrlIMG = "https://syfer001testing.000webhostapp.com/cloneapi/" + imageSW;

                        // Now request the image
                        imageRequest = new ImageRequest(showUrlIMG, new Response.Listener<Bitmap>() {
                            @Override
                            public void onResponse(Bitmap bitmap) {
                                imgDataView.setImageBitmap(bitmap);
                            }
                        }, 0, 0, null, null, new Response.ErrorListener() {
                            @Override
                            public void onErrorResponse(VolleyError volleyError) {
                                Toast.makeText(HomeActivity.this, "Error loading image", Toast.LENGTH_SHORT).show();
                            }
                        });

                        requestQueue.add(imageRequest);
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(HomeActivity.this, error.toString(), Toast.LENGTH_SHORT).show();
                    }
                });

        // Adding request to request queue
        MySingleton.getInstance(this).addToRequestQueue(jsonObjectRequest);
    }

    public void parseJsonData(JSONObject response) {
        try {
            String nameSW = response.getString("name");
            String emailSW = response.getString("email");
            String addressSW = response.getString("address");
            String dobSW = response.getString("dob");
            imageSW = response.getString("file_path");

            nameTextView.setText(nameSW);
            emailTextView.setText(emailSW);
            addressTextView.setText(addressSW);
            dobTextView.setText(dobSW);

        } catch (JSONException e) {
            e.printStackTrace();
            Toast.makeText(HomeActivity.this, "Data parsing error", Toast.LENGTH_SHORT).show();
        }
    }



    public void find(View view) {
        Intent findint = new Intent(HomeActivity.this, SearchActivity.class);
        startActivity(findint);
    }

    public void tutorials(View view) {
        Intent trlint = new Intent(HomeActivity.this, TutorialsActivity.class);
        startActivity(trlint);
    }

    public void book(View view) {
        Intent bkint = new Intent(HomeActivity.this, BookActivity.class);
        startActivity(bkint);
    }

    public void account(View view) {
        Intent actint = new Intent(HomeActivity.this, AccountActivity.class);
        startActivity(actint);
    }

    public void viewAll(View view) {
        Intent viewint = new Intent(HomeActivity.this, UniStudyActivity.class);
        startActivity(viewint);
    }

    public void school(View view) {
        Intent schlint = new Intent(HomeActivity.this, SchoolActivity.class);
        startActivity(schlint);
    }

    public void consultant(View view) {
        Intent conint = new Intent(HomeActivity.this,ConsultantActivity.class);
        startActivity(conint);
    }

    public void college(View view) {
        Intent clgint = new Intent(HomeActivity.this,CollegeActivity.class);
        startActivity(clgint);

    }

    public void network(View view) {
        Intent netint = new Intent(HomeActivity.this,NetworkActivity.class);
        startActivity(netint);
    }

    public void alumni(View view) {
        Intent alumint = new Intent(HomeActivity.this,AlumniActivity.class);
        startActivity(alumint);
    }
}