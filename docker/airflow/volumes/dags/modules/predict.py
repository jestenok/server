from datetime import datetime
import pandas as pd
import dill
import json
import os

path = os.environ.get('PROJECT_PATH', '/opt/airflow/dags/')


def get_raw_test_data():
    test_dir = f'{path}data/test/'
    test_data = []
    for filename in os.listdir(test_dir):
        with open(test_dir + filename, 'rb') as f:
            form = json.load(f)
            test_data.append(form)
    return test_data


def predict():
    file_name = f'{path}data/models/cars_pipe.pkl'
    with open(file_name, 'rb') as file:
        model = dill.load(file)

    test_data = get_raw_test_data()

    df = pd.DataFrame.from_dict(test_data)
    df['predict'] = model.predict(df)
    df.to_csv(f'{path}data/predictions/preds{datetime.now().strftime("%Y%m%d%H%M")}.csv', index=False)


if __name__ == '__main__':
    predict()
