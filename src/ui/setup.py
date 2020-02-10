from setuptools import setup

REQUIREMENTS = [
    "flask",
    "aws-wsgi"
]

setup(
   name='awswebsiteui',
   version='0.0.1',
   description='UI for a website hosted in AWS lambda.',
   author='Will Goodman',
   packages=['awswebsiteUI'],
   install_requires=REQUIREMENTS,
   scripts=[]
)
