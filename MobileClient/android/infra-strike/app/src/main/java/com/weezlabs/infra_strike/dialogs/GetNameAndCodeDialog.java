package com.weezlabs.infra_strike.dialogs;

import android.app.AlertDialog;
import android.app.Dialog;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.weezlabs.infra_strike.R;
import com.weezlabs.infra_strike.datalayer.BtManager;
import com.weezlabs.infra_strike.datalayer.GameManager;

import java.util.zip.Inflater;

/**
 * Created by WeezLabs on 4/9/16.
 */
public class GetNameAndCodeDialog  extends AlertDialog {

    private final OnFinishedListener listener_;
    private final BluetoothDevice bluetoothDevice_;

    public interface OnFinishedListener {
        void finished(String name, String code);
        void canceled();
    };

    public GetNameAndCodeDialog(Context context, BluetoothDevice device, OnFinishedListener listener) {
        super(context, true, null);
        this.listener_ = listener;
        this.bluetoothDevice_ = device;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM);

        setContentView(R.layout.dialog_name_and_code);


        final EditText nameEdit = (EditText) findViewById(R.id.name_edit);
        final TextView irCodeText = (TextView) findViewById(R.id.ir_code);
        final Button buttonOk = (Button) findViewById(R.id.ok_button);
        final Button buttonCancel = (Button) findViewById(R.id.cancel_button);

        buttonOk.setEnabled(false);

        nameEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                buttonOk.setEnabled(!s.toString().isEmpty() && !BtManager.getCurrentIdCode().isEmpty());
            }
        });

        nameEdit.setText("Palladin2001");
        irCodeText.setText(getContext().getText(R.string.ir_code) + BtManager.getCurrentIdCode());

        buttonOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                BtManager.closeBT();
                dismiss();
                listener_.finished(nameEdit.getText().toString(), BtManager.getCurrentIdCode());
            }
        });

        buttonCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                BtManager.closeBT();
                cancel();
                listener_.canceled();
            }
        });

        setOnCancelListener(new OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                BtManager.closeBT();
            }
        });

        BtManager.beginListenForData(bluetoothDevice_, new BtManager.OnGetDataListener() {
            @Override
            public void onGotData(String data) {
                irCodeText.setText(getContext().getText(R.string.ir_code) + data);
                buttonOk.setEnabled(!nameEdit.getText().toString().isEmpty() && !BtManager.getCurrentIdCode().isEmpty());
            }
        });
    }
}
