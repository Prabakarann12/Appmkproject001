package com.example.unistudy;
import android.content.Context;

import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;

public class VolleySingleton {
    private static VolleySingleton minstance;
    private RequestQueue mrequestQueue;
    private static Context mcontext;

    private VolleySingleton(Context context) {
        mcontext = context;
        mrequestQueue = getRequestQueue();
    }

    public static synchronized VolleySingleton getInstance(Context context) {
        if (minstance == null) {
            minstance = new VolleySingleton(context);
        }
        return minstance;
    }

    public RequestQueue getRequestQueue() {
        if (mrequestQueue == null) {
            mrequestQueue = Volley.newRequestQueue(mcontext.getApplicationContext());
        }
        return mrequestQueue;
    }

    public <T> void addToRequestQueue(com.android.volley.Request<T> request) {
        getRequestQueue().add(request);
    }
}
