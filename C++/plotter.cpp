#include <vector>
#include <string>
#include <iostream>
#include <climits>

using namespace std;

/**
 * A quick and dirty command line plotter for the series x, y.
 */
class Plotter {
    static const string bullet;
    static const string space;

    vector<double> x;
    vector<double> y;
    int height;

    public:
    Plotter(vector<double>x_in, vector<double>y_in, int height=6) {
        for (int i=0; i < x_in.size() & i < y_in.size(); ++i) {
            x.push_back(x_in[i]);
            y.push_back(y_in[i]);
        }
        this->height = height;
        plot();
    }

    /**
     * Outputs a multiline string that plots the data x versus y as `*`'s across columns.
     */
    string makeplot() {
        string bullet = "*";
        string space = "-";
        string out = "";
        vector<vector<string> > plotstr;

        float max_y = INT_MIN;
        float min_y = INT_MAX;
        for (int i = 0; i < y.size(); ++i) {
                if (y[i] > max_y) {max_y = y[i];}
                if (y[i] < min_y) {min_y = y[i];}
        }

        float range = max_y - min_y;
        vector<int> y_row;
        for (int i = 0; i < y.size(); ++i) {
                float val = (y[i] - min_y) / range;
                int int_val = static_cast<int>(round(val * (height-1)));
                y_row.push_back(int_val);
        }

        for (int row = 0; row < height; ++row) {
                vector<string> row_str;
                for (int i = 0; i < x.size(); ++i) {
                        row_str.push_back(y_row[i] == row ? bullet : space);
                }
                plotstr.push_back(row_str);
        }

        for (int i = plotstr.size()-1; i >= 0; i = i - 1) {
                out += '|';
                for (int j = 0; j < plotstr[i].size(); ++j) {
                        out += plotstr[i][j];
                }
                out += '\n';
        }

        out += to_string(min_y) + ", " + to_string(max_y) + "; ";
        out += to_string(x[0]) + ", " + to_string(x[x.size()-1]);            
        return out;
    }

    /**
     * Outputs a plot of x versus y to the console.
     */
    void plot() {
        string plotstr = makeplot();
        cout << plotstr << endl;
    }
};