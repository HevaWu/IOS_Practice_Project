from django.test import TestCase
from .models import Music

from rest_framework.test import APIClient
from rest_framework import status
from django.core.urlresolvers import reverse

# Create your tests here.
class ModelTestCase(TestCase):
    """This class defines the test suite for the music model."""

    def setUp(self):
        """Define the test client and other test variables."""
        self.music_name = "Test Music"
        self.music = Music(name = self.music_name)

    # def test_model_can_create_a_music(self):
    #     """Test the music model can create a music."""
    #     old_count = Music.objects.count()
    #     self.music.save()
    #     new_count = Music.objects.count()
    #     self.assertNotEqual(old_count, new_count)

class ViewTestCase(TestCase):
    """Test suite for the api views."""

    def setUp(self):
        """Define the test client and other test variables."""
        self.client = APIClient()
        self.music_data = {'name': 'Music2'}
        self.response = self.client.post(
            reverse('create'),
            self.music_data,
            format="json"
        )

    def test_api_can_create_a_music(self):
        """Test the api has music creation capability."""
        self.assertEqual(self.response.status_code, status.HTTP_201_CREATED)

    def test_api_can_get_a_music(self):
        """Test the api can get a given music."""
        music = Music.objects.get()
        repsonse = self.client.get(
            reverse('details'),
            kwargs={'pk': music.id},
            format = "json" 
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertContains(response, music)

    def test_api_can_update_music(self):
        """Test the api can update a given music."""
        change_music = {'name': 'Music2'}
        res = self.client.put(
            reverse('details', kwargs={'pk':music.id}),
            change_music,
            format = 'json'
        )
        self.assertEqual(res.status_code, status.HTTP_200_OK)

    def test_api_can_delete_music(self):
        """Test the api can delete a music."""
        music = Music.objects.get()
        response = self.client.delete(
            reverse('details', kwargs={'pk': music.id}),
            format = "json",
            follow = True
        )
        self.assertEquals(response.status_code, status.HTTP_204_NO_CONTENT)