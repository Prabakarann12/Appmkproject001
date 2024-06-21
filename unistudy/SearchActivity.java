package com.example.unistudy;

import android.Manifest;
import android.app.DatePickerDialog;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;
import android.app.TimePickerDialog;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TimePicker;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;

import java.io.IOException;
import java.util.Calendar;


import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.SearchView;
import androidx.cardview.widget.CardView;
import androidx.core.app.ActivityCompat;
import androidx.core.view.WindowInsetsCompat;


import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.chip.Chip;
import com.google.android.material.chip.ChipGroup;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Random;

public class SearchActivity extends AppCompatActivity {
    SeekBar priceSeekBar;
    TextView seekTextView,textViewCB;
    Calendar calendar;
    ChipGroup chipGroupSD, chipGroupSL , chipGroupEc , chipGroupTime;
    Chip lastCheckedChip = null;
    int hour, minute;

    FusedLocationProviderClient fusedLocationProviderClient;
    SearchView searchView;
    ImageView desLocBTN;
    ListView listView;
    ArrayAdapter<String> arrayAdapter;
    CardView cardView;
    TextView selectedTextView;
    EditText DestinationET;

    String curAddressUrl = "";

    String UniAddressUrl = "";
    String[] UniAddress = {"University of Toronto (UToronto)", "University of British Columbia (UBC)", "University of Alberta",
            "McGill University", "McMaster University", "University of Montreal"};


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search);
        searchView = findViewById(R.id.search_view);
        listView = findViewById(R.id.List_View);
        cardView = findViewById(R.id.cardView);
        selectedTextView = findViewById(R.id.selected_text);
        priceSeekBar = findViewById(R.id.budgetSeekBar);
        seekTextView = findViewById(R.id.Seek_bar_TV);
        calendar = Calendar.getInstance();
        chipGroupSD = findViewById(R.id.chip_Bar);
        chipGroupSL = findViewById(R.id.chip_bar_location);
        chipGroupEc = findViewById(R.id.chip_Bar_EC);
        DestinationET = findViewById(R.id.Destination_Loc);
        chipGroupTime = findViewById(R.id.chip_Bar_Time);
        listView.setVisibility(View.GONE);
        fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(this);

        arrayAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, UniAddress);
        listView.setAdapter(arrayAdapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long id) {
                // This toast will display the clicked item from the list
                Toast.makeText(SearchActivity.this, "You click " + adapterView.getItemIdAtPosition(i), Toast.LENGTH_SHORT).show();
                String selectedItem = (String) adapterView.getItemAtPosition(i);

                selectedTextView.setText(selectedItem);
                cardView.setVisibility(View.VISIBLE);

                launchActivity(selectedItem);
            }
        });
        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                arrayAdapter.getFilter().filter(query);
                return false;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                arrayAdapter.getFilter().filter(newText);
                return true;
            }
        });
        priceSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            int previousPrice = 10000;
            @Override
            public void onProgressChanged(SeekBar seekBar, int price, boolean b) {

                if (price > previousPrice) {
                    seekTextView.setText("$" + price);
                } else if (price < previousPrice) {
                    seekTextView.setText("$" + price);
                } else {
                    seekTextView.setText("$" + price);
                }
                previousPrice = price;
            }


            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });
    }

    private void launchActivity(String selectedItem) {
        switch (selectedItem) {

            case "University of Toronto (UToronto)":
                UniAddressUrl = "University of Toronto";
                break;
            case "University of British Columbia (UBC)":
                UniAddressUrl = "A.V.C. COLLEGE (Autonomous), 4M3R+4M2, Mayiladuthurai - Akkur Road, Mannampandal, Nagapattinam District, Mayiladuthurai, Tamil Nadu 609305";
                break;
            case "University of Alberta":
                UniAddressUrl = "University of Alberta";
                break;

            default:
                Toast.makeText(this, "No specific action defined for " + selectedItem, Toast.LENGTH_SHORT).show();
                break;
        }
        searchView.setQuery(UniAddressUrl, true);

    }

    public void back(View view) {
        Intent backint = new Intent(SearchActivity.this, HomeActivity.class);
        startActivity(backint);
    }

    public void tutorials(View view) {
        Intent trlint = new Intent(SearchActivity.this, TutorialsActivity.class);
        startActivity(trlint);
    }

    public void book(View view) {
        Intent bkint = new Intent(SearchActivity.this, BookActivity.class);
        startActivity(bkint);
    }

    public void account(View view) {
        Intent actint = new Intent(SearchActivity.this, AccountActivity.class);
        startActivity(actint);
    }

    public void explore(View view) {
        Intent expint = new Intent(SearchActivity.this, HomeActivity.class);
        startActivity(expint);

    }
    public void find(View view) {
        Intent f1int = new Intent(SearchActivity.this, SearchActivity.class);
        startActivity(f1int);
    }


    public void reset(View view) {
    }

    public void apply(View view) {
    }

    public void BudgetSeekbar(View view) {

    }

    public void ChipGroupSD(View v) {
        ArrayList<String> arrayList = new ArrayList<>();
        arrayList.add("Today");
        arrayList.add("Tomorrow");
        arrayList.add("This week");
        arrayList.add("This month");
        arrayList.add("Choose a Date");


        Random random = new Random();
        for (String str : arrayList) {
            Chip chip = (Chip) LayoutInflater.from(SearchActivity.this).inflate(R.layout.chip_layout, chipGroupSD, false);
            chip.setText(str);
            chip.setId(random.nextInt());
            chipGroupSD.addView(chip);
            chip.setOnClickListener(view -> {
                handleChipSelection(chip);
            });
        }
    }

    private void handleChipSelection(Chip chip) {
        if (lastCheckedChip != null && lastCheckedChip.getId() == chip.getId()) {
            chip.setChecked(true);
            return;
        }

        if (lastCheckedChip != null) {
            lastCheckedChip.setChecked(false);
        }

        lastCheckedChip = chip;
        // Handle the selection here based on the chip's text
        switch (chip.getText().toString()) {
            case "Today":
                // Handle Java selection
                break;
            case "Tomorrow":
                // Handle Python selection
                break;
            case "This week":
                // Handle PHP selection
                break;
            case "This month":
                // Handle PHP selection
                break;
            case "Choose a Date":
                int year = calendar.get(Calendar.YEAR);
                int month = calendar.get(Calendar.MONTH);
                int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);

                DatePickerDialog datePickerDialog = new DatePickerDialog(SearchActivity.this,
                        new DatePickerDialog.OnDateSetListener() {
                            @Override
                            public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                                // Do something with the selected date
                                String selectedDate = dayOfMonth + "/" + (month + 1) + "/" + year;

                            }
                        }, year, month, dayOfMonth);

                datePickerDialog.show();
                break;
        }
    }

    public void ChipGroupSL(View v) {
        ArrayList<String> arrayList = new ArrayList<>();
        arrayList.add("use Current Loaction");
        arrayList.add("Search Loaction");
        arrayList.add("Find Loaction");

        Random random = new Random();
        for (String str : arrayList) {
            Chip chip = (Chip) LayoutInflater.from(SearchActivity.this).inflate(R.layout.chip_layout, chipGroupSL, false);
            chip.setText(str);
            chip.setId(random.nextInt());
            chipGroupSL.addView(chip);
            chip.setOnClickListener(view -> {
                handleChipSelectionLoc(chip);
            });
        }
    }

    private void handleChipSelectionLoc(Chip chip) {
        if (lastCheckedChip != null && lastCheckedChip.getId() == chip.getId()) {
            chip.setChecked(true);
            return;
        }

        if (lastCheckedChip != null) {
            lastCheckedChip.setChecked(false);
        }

        lastCheckedChip = chip;

        switch (chip.getText().toString()) {
            case "use Current Loaction":
                if (ActivityCompat.checkSelfPermission(SearchActivity.this, android.Manifest.permission.ACCESS_FINE_LOCATION) == getPackageManager().PERMISSION_GRANTED) {
                    getLocationET();
                } else {
                    ActivityCompat.requestPermissions(SearchActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 44);
                }


                break;
            case "Search Loaction":
                if (listView.getVisibility() == View.VISIBLE) {
                    listView.setVisibility(View.GONE);
                } else {
                    listView.setVisibility(View.VISIBLE);
                }

                break;
            case "Find Loaction":
                String mapSource = searchView.getQuery().toString().trim();
                String mapDestination = DestinationET.getText().toString().trim();

                if (mapSource.isEmpty() || mapDestination.isEmpty()) {
                    Toast.makeText(getApplicationContext(), "Enter both locations", Toast.LENGTH_SHORT).show();
                } else {
                    DisplayTrack(mapSource, mapDestination);
                }

                break;
        }
    }

    private void getLocationET() {
        fusedLocationProviderClient.getLastLocation().addOnCompleteListener(new OnCompleteListener<Location>() {
            @Override
            public void onComplete(@NonNull Task<Location> task) {
                if (task.isSuccessful() && task.getResult() != null) {
                    Location location = task.getResult();

                    if (location != null) {
                        try {
                            Geocoder geocoder = new Geocoder(SearchActivity.this, Locale.getDefault());
                            List<Address> addresses = geocoder.getFromLocation(location.getLatitude(), location.getLongitude(), 1);
                            if (!addresses.isEmpty()) {
                                String addressLine = addresses.get(0).getAddressLine(0);
                                DestinationET.setText(addressLine);
                            }
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                } else {
                    Toast.makeText(SearchActivity.this, "Unable to get location", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    private void DisplayTrack(String mapSource, String mapDestination) {
        String encodedSource = Uri.encode(mapSource);
        String encodedDestination = Uri.encode(mapDestination);


        Uri uri = Uri.parse("https://www.google.com/maps/dir/" + encodedSource + "/" + encodedDestination);
        Intent mapIntent = new Intent(Intent.ACTION_VIEW, uri);
        mapIntent.setPackage("com.google.android.apps.maps");
        mapIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        try {
            startActivity(mapIntent);
        } catch (ActivityNotFoundException e) {
            // If Google Maps app is not installed, open the link in browser
            uri = Uri.parse("https://www.google.com/maps/dir/" + encodedSource + "/" + encodedDestination);
            mapIntent = new Intent(Intent.ACTION_VIEW, uri);
            mapIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(mapIntent);
        }
    }


    public void ChipGroupEC(View v) {
        ArrayList<String> arrayList = new ArrayList<>();
        arrayList.add("Concerts");
        arrayList.add("Parties");
        arrayList.add("Lestening Events");
        arrayList.add("Festivals");
        arrayList.add("tours");


        Random random = new Random();
        for (String str : arrayList) {
            Chip chip = (Chip) LayoutInflater.from(SearchActivity.this).inflate(R.layout.chip_layout, chipGroupEc, false);
            chip.setText(str);
            chip.setId(random.nextInt());
            chipGroupEc.addView(chip);
            chip.setOnClickListener(view -> {
                handleChipSelectionEC(chip);
            });
        }
    }

    private void handleChipSelectionEC(Chip chip) {
        if (lastCheckedChip != null && lastCheckedChip.getId() == chip.getId()) {
            chip.setChecked(true);
            return;
        }

        if (lastCheckedChip != null) {
            lastCheckedChip.setChecked(false);
        }

        lastCheckedChip = chip;

        switch (chip.getText().toString()) {
            case "Concerts":

                break;
            case "Parties":

                break;
            case "Lestening Events":

                break;
            case "Festivals":

                break;
            case "tours":

                break;
        }
    }

    public void ChipGroupTime(View v) {
        ArrayList<String> arrayList = new ArrayList<>();
        arrayList.add("Select Time");

        Random random = new Random();
        for (String str : arrayList) {
            Chip chip = (Chip) LayoutInflater.from(SearchActivity.this).inflate(R.layout.chip_layout, chipGroupTime, false);
            chip.setText(str);
            chip.setId(random.nextInt());
            chipGroupTime.addView(chip);
            chip.setOnClickListener(view -> {
                handleChipSelectionTime(chip);
            });
        }
    }

    private void handleChipSelectionTime(Chip chip) {
        if (lastCheckedChip != null && lastCheckedChip.getId() == chip.getId()) {
            chip.setChecked(true);
            return;
        }

        if (lastCheckedChip != null) {
            lastCheckedChip.setChecked(false);
        }

        lastCheckedChip = chip;
        // Handle the selection here based on the chip's text
        switch (chip.getText().toString()) {
            case "Select Time":
                final Calendar c = Calendar.getInstance();
                hour = c.get(Calendar.HOUR_OF_DAY);
                minute = c.get(Calendar.MINUTE);

                TimePickerDialog timePickerDialog = new TimePickerDialog(SearchActivity.this,
                        new TimePickerDialog.OnTimeSetListener() {

                            @Override
                            public void onTimeSet(TimePicker view, int hourOfDay, int minuteOfDay) {
                                hour = hourOfDay;
                                minute = minuteOfDay;

                                Toast.makeText(getApplicationContext(), hour + ":" + minute, Toast.LENGTH_SHORT).show();
                            }
                        }, hour, minute, false);
                timePickerDialog.show();
                break;
        }
    }


}