from django.db import models

# Create your models here.
class Music(models.Model):
    """This class represents a music model."""
    name = models.CharField(max_length=100)
    rating = models.IntegerField()
    photoURLString = models.CharField(max_length = 1000)

    def __str__(self):
        """Reture a human readable representation of the model instance."""
        return "{}".format(self.name, self.rating, self.photoURLString)

