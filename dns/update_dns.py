#!/usr/bin/env python3

import os

import dotenv
import requests

dotenv.load_dotenv()
token = os.environ['DO_API_TOKEN']
domain = os.environ['DO_DOMAIN']
subdomains = os.environ['DO_SUBDOMAINS'].split(',')

records_url = f'https://api.digitalocean.com/v2/domains/{domain}/records/'
session = requests.Session()
session.headers = {
    'Authorization': 'Bearer ' + token
}


def get_current_ip():
    """ Get current IP address from ipify.org """
    return requests.get('https://api.ipify.org').text.rstrip()


def get_sub_info(subdomain):
    """ Get subdomain record info from DigitalOcean API """
    records = session.get(records_url).json()
    for record in records['domain_records']:
        if record['name'] == subdomain and record['type'] == 'A':
            return record


def update_dns():
    """ Update subdomain record with current IP address """
    current_ip_address = get_current_ip()

    for subdomain in subdomains:
        sub_info = get_sub_info(subdomain)
        subdomain_ip_address = sub_info['data']
        subdomain_record_id = sub_info['id']
        if current_ip_address == subdomain_ip_address:
            print('Subdomain DNS record does not need updating.')
        else:
            body = {'type': 'A', 'name': subdomain, 'data': current_ip_address}
            response = session.put(f'{records_url}{subdomain_record_id}', json=body)
            if response.ok:
                print('Subdomain IP address updated to ' + current_ip_address)
            else:
                print('IP address update failed with message: ' + response.text)


if __name__ == '__main__':
    update_dns()
