package com.example.unistudy;

import android.app.DatePickerDialog;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Base64;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.material.textfield.TextInputEditText;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;


public class RegisterActivity extends AppCompatActivity {

    TextInputEditText emailEt, passwordEt, nameEt, confirmPassword, dateOfEt, addressEt;
    Button signUp;
    Bitmap bitmap;
    ImageView ViewIMG, broseIMG,calendar_rp;
    String encodeImageString ;
    String url = "https://syfer001testing.000webhostapp.com/cloneapi/cloneapi1.php";
    public final int GALLERY_REQUEST_CODE = 1000000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);
        calendar_rp = findViewById(R.id.calendar_RG);
        nameEt = findViewById(R.id.nameEdit);
        emailEt = findViewById(R.id.emailEdit);
        passwordEt = findViewById(R.id.passwordEdit);
        confirmPassword = findViewById(R.id.confirmEdit);
        dateOfEt = findViewById(R.id.dateOfBirthEdit);
        addressEt = findViewById(R.id.addressEdit);
        signUp = findViewById(R.id.sign_up);
        ViewIMG = findViewById(R.id.View_image);
        broseIMG = findViewById(R.id.brose_image);

        broseIMG.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent browse = new Intent(Intent.ACTION_PICK);
                browse.setData(MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                startActivityForResult(browse, GALLERY_REQUEST_CODE);

            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == GALLERY_REQUEST_CODE && data != null) {
            Uri selectedImageUri = data.getData();
            if (selectedImageUri != null) {
                try {
                    bitmap = MediaStore.Images.Media.getBitmap(this.getContentResolver(), selectedImageUri);
                    ViewIMG.setImageBitmap(bitmap);
                    encodeBitmapImage(bitmap);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void encodeBitmapImage(Bitmap bitmap) {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
        byte[] bytesOfImage = byteArrayOutputStream.toByteArray();
        encodeImageString = Base64.encodeToString(bytesOfImage, Base64.DEFAULT);
    }

    public void register(View view) {
        String name = nameEt.getText().toString().trim();
        String email = emailEt.getText().toString().trim();
        String password = passwordEt.getText().toString().trim();
        String confirmPwd = confirmPassword.getText().toString().trim();
        String dob = dateOfEt.getText().toString().trim();
        String address = addressEt.getText().toString().trim();

        if (!password.equals(confirmPwd)) {
            Toast.makeText(RegisterActivity.this, "Passwords do not match", Toast.LENGTH_SHORT).show();
            return;
        }

        registerUser(name, email, password, dob, address);
    }



    private void registerUser(String name, String email, String password, String dob, String address) {
        StringRequest request = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        nameEt.setText("");
                        emailEt.setText("");
                        passwordEt.setText("");
                        addressEt.setText("");
                        dateOfEt.setText("");
                        ViewIMG.setImageResource(R.drawable.ic_launcher_foreground);
                        Toast.makeText(getApplicationContext(), response, Toast.LENGTH_LONG).show();
                        Toast.makeText(RegisterActivity.this, response, Toast.LENGTH_SHORT).show();
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(RegisterActivity.this, error.getMessage(), Toast.LENGTH_SHORT).show();
            }
        }) {
            @Nullable
            @Override
            protected Map<String, String> getParams() throws AuthFailureError {
                Map<String, String> map = new HashMap<>();
                map.put("requestby", "RegisterData");
                map.put("name", name);
                map.put("email", email);
                map.put("password", password);
                map.put("dob", dob);
                map.put("address", address);
                map.put("image", encodeImageString);
                return map;
            }
        };

        request.setRetryPolicy(new DefaultRetryPolicy(
                5000,
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT
        ));

        RequestQueue requestQueue = Volley.newRequestQueue(this);
        requestQueue.add(request);
    }


    public void calendar(View view) {
        Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);

        DatePickerDialog datePickerDialog = new DatePickerDialog(RegisterActivity.this,
                new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                        String selectedDate = year + "/" + (month + 1) + "/" + dayOfMonth;
                        dateOfEt.setText(selectedDate);
                    }
                }, year, month, dayOfMonth);

        datePickerDialog.show();
    }

}