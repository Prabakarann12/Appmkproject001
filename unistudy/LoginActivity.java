package com.example.unistudy;

import static com.android.volley.VolleyLog.TAG;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.NotificationCompat;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.UrlRewriter;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.auth.api.signin.GoogleSignInStatusCodes;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.tasks.Task;
import com.google.android.material.textfield.TextInputEditText;

import java.util.HashMap;
import java.util.Map;

public class LoginActivity extends AppCompatActivity {
    TextInputEditText emailEt, passwordEt;
    private static final int RC_SIGN_IN = 9001;
    ImageView SignIn, Google, Facebook, Create;
    ProgressBar progressBar;
    String url = "https://syfer001testing.000webhostapp.com/cloneapi/cloneapi1.php";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        progressBar = findViewById(R.id.progressBar);
        emailEt = findViewById(R.id.emailEditText);
        passwordEt = findViewById(R.id.passwordEditText);
        SignIn = findViewById(R.id.Login);
        Google = findViewById(R.id.google);
        Facebook = findViewById(R.id.facebook);
        Create = findViewById(R.id.Create);
        GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestEmail()
                .build();


        GoogleSignInClient googleSignInClient = GoogleSignIn.getClient(this, gso);
        GoogleSignInAccount googleSignInAccount = GoogleSignIn.getLastSignedInAccount(this);
        if (googleSignInAccount != null){
            startActivity(new Intent(LoginActivity.this,GoogleActivity.class));
            finish();
        }
        ActivityResultLauncher<Intent> activityResultLauncher = registerForActivityResult(new ActivityResultContracts.StartActivityForResult(), new ActivityResultCallback<ActivityResult>() {
            @Override
            public void onActivityResult(ActivityResult result) {
                if (result.getResultCode() == RESULT_OK) {
                    Intent data = result.getData();
                    Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
                    handleSignInTask(task);
                } else {
                    Toast.makeText(LoginActivity.this, "Google Sign-In failed.", Toast.LENGTH_SHORT).show();
                }
            }
        });

        Google.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent signInIntent = googleSignInClient.getSignInIntent();
                activityResultLauncher.launch(signInIntent);
            }
        });

    }


    private void handleSignInTask(Task<GoogleSignInAccount> task) {
        try {
            GoogleSignInAccount account = task.getResult(ApiException.class);
            if (account != null) {
                final String getFullname = account.getDisplayName();
                final String getEmail = account.getEmail();
                final Uri getPhotoUrl = account.getPhotoUrl();
                Log.d(TAG, "Google Sign-In successful: " + getEmail);
                startActivity(new Intent(LoginActivity.this, GoogleActivity.class));
                finish();
            }
        } catch (ApiException e) {
            Log.e(TAG, "Google Sign-In failed: " + e.getStatusCode(), e);
            Toast.makeText(this, "Failed or Cancelled: " + e.getStatusCode(), Toast.LENGTH_SHORT).show();
        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == RC_SIGN_IN) {
            Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
            handleSignInResult(task);
        }
    }

    private void handleSignInResult(Task<GoogleSignInAccount> completedTask) {
        try {
            GoogleSignInAccount account = completedTask.getResult(ApiException.class);
            updateUI(account);
        } catch (ApiException e) {
            Log.w(TAG, "signInResult:failed code=" + e.getStatusCode(), e);
            switch (e.getStatusCode()) {
                case GoogleSignInStatusCodes.SIGN_IN_FAILED:
                    Log.e(TAG, "Sign in failed.");
                    break;
                case GoogleSignInStatusCodes.NETWORK_ERROR:
                    Log.e(TAG, "Network error.");
                    break;
                case GoogleSignInStatusCodes.INVALID_ACCOUNT:
                    Log.e(TAG, "Invalid account.");
                    break;
                default:
                    Log.e(TAG, "Unknown error.");
                    break;
            }
            updateUI(null);
        }
    }

    private void updateUI(GoogleSignInAccount account) {
        Google = findViewById(R.id.google);


        if (account != null) {
            Toast.makeText(this, "Sign-in successful!", Toast.LENGTH_SHORT).show();
            Google.setVisibility(View.GONE);

            // Navigate to HomeActivity
            Intent intent = new Intent(LoginActivity.this, HomeActivity.class);
            startActivity(intent);
            finish(); // Optional: Call finish() if you want to close the SignInActivity
        } else {
            Toast.makeText(this, "Sign-in failed.", Toast.LENGTH_SHORT).show();
            Google.setVisibility(View.VISIBLE);

        }
    }





    public void logIn(View view) {
        String email = emailEt.getText().toString();
        String password = passwordEt.getText().toString();

        if (isValied(email, password)){
            progressBar.setVisibility(View.VISIBLE);
            signIn(email,password);
        }

    }
    private void showMessage(String msg) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
    }
    private boolean isValied(String email, String password) {
        if (email.isEmpty()){
            showMessage("email is empty");
            emailEt.setText(null);
            return false;
        }
        if (password.isEmpty()){
            showMessage("password is empty");
            passwordEt.setText(null);
            return false;
        }
        return true;
    }
    private void signIn(String email, String password) {
        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        progressBar.setVisibility(View.GONE);
                        Log.d("Response", "Response received: " + response);
                        if (response == null) {
                            Log.w("Unexpected Response", "Response is null");
                            showMessage("Unexpected response from server. Please try again later.");
                        } else {
                            if ("success".equalsIgnoreCase(response.trim())) {
                                makeNotification();
                                Intent homeIntent = new Intent(LoginActivity.this, HomeActivity.class);
                                homeIntent.putExtra("email", email);
                                startActivity(homeIntent);
                                emailEt.setText("");
                                passwordEt.setText("");
                            } else if ("Login failed".equalsIgnoreCase(response.trim())) {
                                showMessage("Invalid email or password");
                            } else {
                                Log.w("Unexpected Response", "Received unexpected response from server: " + response);
                                showMessage("Unexpected response from server. Please try again later.");
                            }
                        }
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        progressBar.setVisibility(View.GONE);
                        showMessage("Please check your internet connection");
                        Log.e("Volley Error", error.toString());
                    }
                }) {
            @Override
            protected Map<String, String> getParams() {
                Map<String, String> map = new HashMap<>();
                map.put("requestby", "Logindata");
                map.put("email", email);
                map.put("password", password);
                return map;
            }
        };

        VolleySingleton.getInstance(this).addToRequestQueue(stringRequest);

    }


    private void makeNotification() {
        String chennelId = "CHENNEL_ID_NOTIFICATION";
        NotificationCompat.Builder builder = new NotificationCompat.Builder(getApplicationContext(), chennelId);
        builder.setSmallIcon(R.drawable.ic_notifications)
                .setContentTitle("NOTIFICATION")
                .setContentText("Welcome to UniStudy")
                .setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);
        Intent intent = new Intent(getApplicationContext(), Notification.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.putExtra("data", "Welcome to UniStudy");


        PendingIntent pendingIntent = PendingIntent.getActivities(getApplicationContext(),
                0, new Intent[]{intent}, PendingIntent.FLAG_MUTABLE);
        builder.setContentIntent(pendingIntent);
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel = notificationManager.getNotificationChannel(chennelId);
            if (notificationChannel == null) {
                int importans = NotificationManager.IMPORTANCE_HIGH;
                notificationChannel = new NotificationChannel(chennelId, "Some description", importans);
                notificationChannel.setDescription("This channel is for important notifications from the app.");
                notificationChannel.setLightColor(Color.GREEN);
                notificationChannel.enableVibration(true);
                notificationManager.createNotificationChannel(notificationChannel);
            }
        }
        notificationManager.notify(0, builder.build());
    }

    public void google(View view) {

    }

    public void facebook(View view) {
        Intent faceint = new Intent(LoginActivity.this, HomeActivity.class);
        startActivity(faceint);
    }

    public void create(View view) {
        Intent crtint = new Intent(LoginActivity.this, RegisterActivity.class);
        startActivity(crtint);
    }
}

