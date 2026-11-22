package com.yg.aprs;

import android.content.Context;
import android.content.res.TypedArray;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.SpinnerAdapter;
import android.widget.TextView;

/**
 * APRS 图标列表适配器：下拉行完全由代码构建，
 * 不依赖 XML 布局、不依赖 getChildAt 之类的脆弱假设，
 * 任何异常都降级为纯文字行而不是崩溃。
 */
public class SymbolAdapter extends BaseAdapter implements SpinnerAdapter {

    private final Context ctx;
    private final String[] labels;
    private final TypedArray icons;
    private final int iconSize;
    private final int pad;

    public SymbolAdapter(Context context, String[] labels) {
        this.ctx = context;
        this.labels = (labels == null) ? new String[0] : labels;
        TypedArray ta = null;
        try {
            int id = context.getResources().getIdentifier(
                    "symbol_icons", "array", context.getPackageName());
            if (id != 0) {
                ta = context.getResources().obtainTypedArray(id);
            }
        } catch (Throwable t) {
            ta = null;
        }
        this.icons = ta;
        float d = context.getResources().getDisplayMetrics().density;
        if (d <= 0f) {
            d = 2f;
        }
        this.iconSize = (int) (30f * d + 0.5f);
        this.pad = (int) (8f * d + 0.5f);
    }

    @Override
    public int getCount() {
        return labels == null ? 0 : labels.length;
    }

    @Override
    public Object getItem(int position) {
        if (labels == null || position < 0 || position >= labels.length) {
            return "";
        }
        return labels[position];
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        return bind(position, convertView);
    }

    @Override
    public View getDropDownView(int position, View convertView, ViewGroup parent) {
        return bind(position, convertView);
    }

    private View bind(int position, View convertView) {
        try {
            LinearLayout row;
            if (convertView instanceof LinearLayout
                    && ((LinearLayout) convertView).getChildCount() == 2) {
                row = (LinearLayout) convertView;
            } else {
                row = buildRow();
            }
            View icon = row.getChildAt(0);
            View text = row.getChildAt(1);
            if (text instanceof TextView) {
                ((TextView) text).setText(getItem(position).toString());
            }
            if (icon instanceof ImageView) {
                ImageView iv = (ImageView) icon;
                int res = 0;
                if (icons != null) {
                    try {
                        res = icons.getResourceId(position, 0);
                    } catch (Throwable ignored) {
                        res = 0;
                    }
                }
                if (res != 0) {
                    try {
                        iv.setImageResource(res);
                    } catch (Throwable t) {
                        iv.setImageDrawable(null);
                    }
                } else {
                    iv.setImageDrawable(null);
                }
            }
            return row;
        } catch (Throwable t) {
            return buildFallback(position);
        }
    }

    private LinearLayout buildRow() {
        LinearLayout row = new LinearLayout(ctx);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);
        row.setPadding(pad, pad, pad, pad);

        ImageView iv = new ImageView(ctx);
        iv.setLayoutParams(new LinearLayout.LayoutParams(iconSize, iconSize));
        iv.setScaleType(ImageView.ScaleType.FIT_CENTER);
        iv.setContentDescription(null);

        TextView tv = new TextView(ctx);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f);
        lp.setMarginStart(pad + 4);
        tv.setLayoutParams(lp);
        tv.setTextSize(14f);
        tv.setTextColor(0xFFE8EEF6);
        tv.setSingleLine(true);
        tv.setEllipsize(TextUtils.TruncateAt.END);

        row.addView(iv);
        row.addView(tv);
        return row;
    }

    private View buildFallback(int position) {
        TextView tv = new TextView(ctx);
        tv.setText(getItem(position).toString());
        tv.setTextSize(14f);
        tv.setTextColor(0xFFE8EEF6);
        tv.setPadding(pad, pad, pad, pad);
        return tv;
    }
}
