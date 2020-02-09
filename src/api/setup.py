from setuptools import setup

REQUIREMENTS = [
    "flask",
    "aws-wsgi"
]

setup(
   name='awswebsiteapi',
   version='0.0.1',
   description='API for a website hosted in AWS lambda.',
   author='Will Goodman',
   packages=['awswebsiteapi'],
   install_requires=REQUIREMENTS,
   scripts=[]
)
