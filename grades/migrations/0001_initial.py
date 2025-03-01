# Generated by Django 5.0.4 on 2025-02-08 09:57

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Grade',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('grade_name', models.CharField(max_length=50, unique=True, verbose_name='班级名称')),
                ('grade_number', models.CharField(max_length=10, unique=True, verbose_name='班级编号')),
            ],
            options={
                'verbose_name': '班级',
                'verbose_name_plural': '班级名称',
                'db_table': 'grade',
            },
        ),
    ]
