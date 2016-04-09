package com.weezlabs.infra_strike.utils;

import android.content.Context;
import android.database.Cursor;
import android.provider.ContactsContract;

import com.weezlabs.infra_strike.models.Contact;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by WeezLabs on 4/9/16.
 */
public class ContactUtils {
    public static ArrayList<Contact> getContacts(Context context) {
        ArrayList<Contact> result = new ArrayList<Contact>();
        HashMap<String, String> phoneNameMapping = new HashMap<>();
        Cursor phones = context.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
        while (phones.moveToNext()) {
            String name = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));
            String phoneNumber = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));

            phoneNameMapping.put(phoneNumber, name);
        }
        phones.close();

        for (String phoneNumber: phoneNameMapping.keySet()) {

            Contact contact = new Contact();
            contact.phone = phoneNumber;
            contact.name = phoneNameMapping.get(phoneNumber);
            result.add(contact);
        }
        return result;
    }
}
