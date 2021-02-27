#include <algorithm>
#include <iostream>
#include <unordered_map>
#include <vector>
using namespace std;

// global vars

class Street {
   public:
    int b, e;
    string name;
    int l;
    int carsCount = 0;
    Street() {}
    /* Street(int b, int e, string name, int l) {
        this->b = b;
        this->e = e;
        this->name = name;
        this->l = l;
    } */
};

class Car {
   public:
    int p;
    vector<string> streets;
};

bool compareStreets(const Street &s1, const Street &s2) {
    return s1.carsCount < s2.carsCount;
}

class Intersection {
   public:
    int id;
    vector<pair<string, int>> paths;
};

int32_t
main() {
    // Bind files to I/O streams.
    freopen("f.txt", "r", stdin);
    freopen("f-sol.txt", "w", stdout);

    int d, i, s, v, f;

    // Start coding from here.
    cin >> d >> i >> s >> v >> f;

    unordered_map<int, Intersection> id_interestion;

    unordered_map<string, Street> name_street;

    for (int i = 0; i < s; i++) {
        Street street;
        cin >> street.b >> street.e >> street.name >> street.l;
        name_street[street.name] = street;
    }

    for (int i = 0; i < v; i++) {
        Car car;
        cin >> car.p;
        for (int i = 0; i < car.p; i++) {
            string streetName;
            cin >> streetName;
            name_street[streetName].carsCount++;
            car.streets.push_back(streetName);
        }
    }

    vector<Street> streets;
    for (auto p : name_street) {
        streets.push_back(p.second);
    }
    sort(streets.begin(), streets.end(), compareStreets);

    int time = 0;
    int prevCarsCount = 0;
    for (auto street : streets) {
        if (street.carsCount > 0) {
            if (street.carsCount > prevCarsCount) time++;
            prevCarsCount = street.carsCount;
            int streetEnd = street.e;
            auto ref = id_interestion.find(streetEnd);
            if (ref == id_interestion.end()) {
                Intersection ints;
                ints.id = streetEnd;
                id_interestion[streetEnd] = ints;
                id_interestion[streetEnd].paths.push_back({street.name, time});
            } else {
                Intersection &ints = id_interestion[streetEnd];
                ints.paths.push_back({street.name, time});
            }
        }
    }

    int intsCount = 0;
    for (auto p : id_interestion) {
        if (p.second.paths.size() > 0) {
            intsCount++;
        }
    }

    cout << intsCount << endl;
    for (auto p : id_interestion) {
        if (p.second.paths.size() > 0) {
            cout << p.first << endl;
            cout << p.second.paths.size() << endl;
            for (auto e : p.second.paths) {
                cout << e.first << ' ' << e.second << endl;
            }
        }
    }

    return 0;
}